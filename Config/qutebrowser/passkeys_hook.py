"""Answer prompt() calls from greasemonkey/passkeys.js through qute-keepassxc."""

import inspect
import json
import os
import pathlib
import platform
import shutil
import subprocess

import qutebrowser
from qutebrowser.qt.core import QEventLoop, QProcess, QProcessEnvironment, QTimer, qVersion
from qutebrowser.utils import log, message, standarddir

PREFIX = "qute-passkeys:"
PROTOCOL = 1
HELPER = pathlib.Path(__file__).parent / "userscripts" / "qute-keepassxc"
SCRIPT = pathlib.Path(__file__).parent / "greasemonkey" / "passkeys.js"
HELPER_TIMEOUT_MS = 180_000
CHECK_TIMEOUT_S = 10

ERROR_NOT_RUNNING = -1
ERROR_ORIGIN_NOT_ALLOWED = 26
ERROR_CANCELLED = 22
ERROR_UNKNOWN = 31
# These mean the integration is broken, unlike a locked database or a cancelled dialog.
BROKEN_ERRORS = {2, 3, 4, 7, 8, 9, 10, 12, 13, ERROR_UNKNOWN}
SILENT_ERRORS = {6, ERROR_CANCELLED}
HINTS = {
    ERROR_NOT_RUNNING: "KeePassXC is not running",
    1: "the KeePassXC database is locked",
    15: "KeePassXC has no passkey for this site",
    21: "this passkey is already registered",
}


def _state_path() -> pathlib.Path:
    return pathlib.Path(standarddir.data()) / "passkeys-alerts.json"


def _load_state() -> dict:
    try:
        return json.loads(_state_path().read_text())
    except (OSError, ValueError):
        return {}


def _save_state(state: dict) -> None:
    _state_path().write_text(json.dumps(state))


def _fingerprint() -> str:
    from qutebrowser.qt.webenginecore import qWebEngineVersion

    keepassxc = shutil.which("keepassxc")
    parts = [
        qutebrowser.__version__,
        qVersion(),
        qWebEngineVersion(),
        platform.python_version(),
        str(os.stat(keepassxc).st_mtime_ns) if keepassxc else "no-keepassxc",
    ]
    return " ".join(parts)


def _alert(kind: str, text: str, *, attempt: bool = True) -> None:
    """Show a failure once until it recovers or something gets updated."""
    text = f"qute-passkeys: {text}"
    state = _load_state()
    alerted = state.setdefault("alerted", [])
    if kind in alerted:
        log.misc.warning(text)
        if attempt:
            message.warning(text)
        return
    alerted.append(kind)
    _save_state(state)
    message.error(text)
    QProcess.startDetached("rofi", ["-e", text])


def _clear_alerts() -> None:
    state = _load_state()
    if state.get("alerted"):
        state["alerted"] = []
        _save_state(state)


def _helper_environment() -> QProcessEnvironment:
    env = QProcessEnvironment.systemEnvironment()
    env.insert("QUTE_DATA_DIR", standarddir.data())
    env.insert("QUTE_FIFO", os.devnull)
    return env


def _ask_keepassxc(request: dict, gpg_key: str, abort_on: list) -> dict:
    process = QProcess()
    process.setProcessEnvironment(_helper_environment())
    loop = QEventLoop()
    process.finished.connect(loop.quit)
    process.errorOccurred.connect(lambda _error: loop.quit())
    for signal in abort_on:
        signal.connect(loop.quit)
    QTimer.singleShot(HELPER_TIMEOUT_MS, loop.quit)
    process.start(str(HELPER), ["--passkey", "--key", gpg_key])
    process.write(json.dumps(request).encode())
    process.closeWriteChannel()
    loop.exec()
    if process.state() != QProcess.ProcessState.NotRunning:
        process.kill()
        process.waitForFinished(1000)
        return {"errorCode": ERROR_CANCELLED, "errorMessage": "The request was aborted or timed out"}
    return json.loads(bytes(process.readAllStandardOutput()))


def _serve_passkey(url, request: dict, gpg_key: str, abort_on: list) -> dict:
    if url.scheme() != "https":
        return {"errorCode": ERROR_ORIGIN_NOT_ALLOWED, "errorMessage": "Passkeys require https"}
    request = {
        "action": request["action"],
        "publicKey": request["publicKey"],
        "origin": url.toString().rstrip("/"),
    }
    response = _ask_keepassxc(request, gpg_key, abort_on)
    code = response.get("errorCode")
    if code is None:
        _clear_alerts()
        return {"publicKey": response}
    detail = response.get("errorMessage")
    if code in BROKEN_ERRORS:
        _alert(f"keepassxc-{code}", f"KeePassXC error {code}: {detail}")
    elif code not in SILENT_ERRORS:
        message.warning(f"Passkey failed: {HINTS.get(code, detail or f'KeePassXC error {code}')}")
    return response


def _serve(url, request: dict, gpg_key: str, abort_on: list) -> dict:
    action = request.get("action")
    if action == "ping":
        return {"protocol": PROTOCOL}
    if action == "report":
        _alert("script", "greasemonkey/passkeys.js failed, see its console error")
        return {}
    if action in ("passkeys-get", "passkeys-register"):
        return _serve_passkey(url, request, gpg_key, abort_on)
    return {"errorCode": ERROR_UNKNOWN, "errorMessage": "Unknown action"}


def _make_hook(original, gpg_key: str):
    def javascript_prompt(url, js_msg, default, abort_on):
        if not js_msg.startswith(PREFIX):
            return original(url, js_msg, default, abort_on)
        try:
            reply = _serve(url, json.loads(js_msg.removeprefix(PREFIX)), gpg_key, abort_on)
        except Exception as e:
            _alert("hook", f"the bridge failed: {e!r}")
            reply = {"errorCode": ERROR_UNKNOWN, "errorMessage": "The passkey hook failed"}
        return (True, json.dumps(reply))

    return javascript_prompt


def _find_problem() -> str | None:
    """Describe why the qutebrowser internals no longer fit the hook, if they don't."""
    from qutebrowser.browser import shared
    from qutebrowser.browser.webengine import webview

    if not SCRIPT.is_file():
        return f"{SCRIPT} is missing"
    if not os.access(HELPER, os.X_OK):
        return f"{HELPER} is not executable"
    parameters = list(inspect.signature(shared.javascript_prompt).parameters)
    if parameters != ["url", "js_msg", "default", "abort_on"]:
        return f"shared.javascript_prompt now takes {parameters}"
    if "return (True, answer)" not in inspect.getsource(shared.javascript_prompt):
        return "shared.javascript_prompt changed its return value"
    if "shared.javascript_prompt(" not in inspect.getsource(webview.WebEnginePage.javaScriptPrompt):
        return "WebEnginePage.javaScriptPrompt no longer uses shared.javascript_prompt"
    return None


def _check_helper() -> str | None:
    try:
        env = dict(os.environ, QUTE_DATA_DIR=standarddir.data(), QUTE_FIFO=os.devnull)
        result = subprocess.run([HELPER, "--passkey-check"], env=env, capture_output=True, text=True,
                                timeout=CHECK_TIMEOUT_S, check=False)
    except (OSError, subprocess.TimeoutExpired) as e:
        return f"qute-keepassxc check failed: {e}"
    if result.returncode != 0 or result.stdout.strip() != "ok":
        return f"qute-keepassxc check failed: {(result.stderr or result.stdout).strip()[-200:]}"
    return None


def _start_up_checks() -> bool:
    fingerprint = _fingerprint()
    state = _load_state()
    if state.get("fingerprint") != fingerprint:
        _save_state({"fingerprint": fingerprint, "alerted": []})
        problem = _check_helper()
        if problem:
            _alert("helper", problem, attempt=False)
    problem = _find_problem()
    if problem:
        _alert("internals", f"{problem}, passkeys are off", attempt=False)
    return problem is None


def install(gpg_key: str) -> None:
    """Hook the JS prompt handler, unless qutebrowser internals have changed."""
    try:
        from qutebrowser.browser import shared

        already_hooked = _make_hook.__name__ in shared.javascript_prompt.__qualname__
        if _start_up_checks() and not already_hooked:
            shared.javascript_prompt = _make_hook(shared.javascript_prompt, gpg_key)
    except Exception as e:
        _alert("install", f"could not install the hook: {e!r}", attempt=False)
