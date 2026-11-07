// ==UserScript==
// @name        qute-passkeys
// @description Serve WebAuthn from KeePassXC through passkeys_hook.py
// @match       https://*/*
// @run-at      document-start
// ==/UserScript==

(() => {
    "use strict";

    const PREFIX = "qute-passkeys:";
    const PROTOCOL = 1;
    const MIN_TIMEOUT = 15000;
    const DEFAULT_TIMEOUT = 30000;
    const MAX_TIMEOUT = 120000;
    const INVALID_INPUT_ERRORS = [32, 33];
    const ERROR_NAMES = {
        27: "SecurityError",
        28: "SecurityError",
        29: "NotSupportedError",
    };

    const bytesOf = (source) =>
        source instanceof ArrayBuffer
            ? new Uint8Array(source)
            : new Uint8Array(source.buffer, source.byteOffset, source.byteLength);

    const toBase64Url = (source) =>
        btoa(String.fromCharCode(...bytesOf(source)))
            .replaceAll("+", "-")
            .replaceAll("/", "_")
            .replaceAll("=", "");

    const fromBase64Url = (text) =>
        Uint8Array.from(atob(text.replaceAll("-", "+").replaceAll("_", "/")), (c) => c.charCodeAt(0)).buffer;

    const callHook = (request) => {
        const answer = window.prompt(PREFIX + JSON.stringify(request));
        try {
            return JSON.parse(answer);
        } catch {
            return null;
        }
    };

    let hookActive;
    const isHookActive = () => {
        hookActive ??= callHook({
            action: "ping",
            note: "The passkey hook is inactive, check passkeys_hook.py",
        })?.protocol === PROTOCOL;
        return hookActive;
    };

    const encodeExtensions = (extensions) => {
        const first = extensions?.prf?.eval?.first;
        return first
            ? { ...extensions, prf: { ...extensions.prf, eval: { ...extensions.prf.eval, first: toBase64Url(first) } } }
            : extensions;
    };

    const encodeDescriptor = ({ id, transports, type }) => ({ id: toBase64Url(id), transports, type });

    const dialogTimeout = (requested, userVerification) => {
        const timeout = Number(requested);
        if (!timeout) {
            return userVerification === "discouraged" ? MAX_TIMEOUT : DEFAULT_TIMEOUT;
        }
        return timeout < MIN_TIMEOUT || timeout > MAX_TIMEOUT ? DEFAULT_TIMEOUT : timeout;
    };

    const encodeCreationOptions = (options) => ({
        attestation: options.attestation,
        authenticatorSelection: options.authenticatorSelection,
        challenge: toBase64Url(options.challenge),
        excludeCredentials: (options.excludeCredentials ?? []).map(encodeDescriptor),
        extensions: encodeExtensions(options.extensions),
        pubKeyCredParams: options.pubKeyCredParams.map(({ alg, type }) => ({ alg: Number(alg) || 0, type })),
        rp: options.rp,
        timeout: dialogTimeout(options.timeout, options.authenticatorSelection?.userVerification),
        user: { ...options.user, id: toBase64Url(options.user.id) },
    });

    const encodeRequestOptions = (options) => ({
        allowCredentials: (options.allowCredentials ?? []).map(encodeDescriptor),
        challenge: toBase64Url(options.challenge),
        enterpriseAttestationPossible: false,
        extensions: encodeExtensions(options.extensions),
        rpId: options.rpId,
        timeout: dialogTimeout(options.timeout, options.userVerification),
        userVerification: options.userVerification,
    });

    const decodeExtensionResults = (results = {}) => {
        const first = results.prf?.results?.first;
        return first ? { ...results, prf: { ...results.prf, results: { first: fromBase64Url(first) } } } : results;
    };

    const buildAttestation = (response) =>
        Object.setPrototypeOf({
            attestationObject: fromBase64Url(response.attestationObject),
            clientDataJSON: fromBase64Url(response.clientDataJSON),
            getAuthenticatorData: () => fromBase64Url(response.authenticatorData),
            getPublicKey: () => (response.publicKey ? fromBase64Url(response.publicKey) : null),
            getPublicKeyAlgorithm: () => response.publicKeyAlgorithm,
            getTransports: () => ["internal"],
        }, AuthenticatorAttestationResponse.prototype);

    const buildAssertion = (response) =>
        Object.setPrototypeOf({
            authenticatorData: fromBase64Url(response.authenticatorData),
            clientDataJSON: fromBase64Url(response.clientDataJSON),
            signature: fromBase64Url(response.signature),
            userHandle: response.userHandle ? fromBase64Url(response.userHandle) : null,
        }, AuthenticatorAssertionResponse.prototype);

    const buildCredential = (credential) => {
        const { response } = credential;
        const extensionResults = decodeExtensionResults(response.clientExtensionResults);
        const toJSON = () => ({
            id: credential.id,
            rawId: credential.id,
            authenticatorAttachment: credential.authenticatorAttachment,
            clientExtensionResults: response.clientExtensionResults ?? {},
            response: {
                ...response,
                clientExtensionResults: undefined,
                ...(response.attestationObject ? { transports: ["internal"] } : {}),
            },
            type: credential.type,
        });
        return Object.setPrototypeOf({
            authenticatorAttachment: credential.authenticatorAttachment,
            getClientExtensionResults: () => extensionResults,
            id: credential.id,
            rawId: fromBase64Url(credential.id),
            response: response.attestationObject ? buildAttestation(response) : buildAssertion(response),
            toJSON,
            type: credential.type,
        }, PublicKeyCredential.prototype);
    };

    const abortError = (signal) => signal.reason ?? new DOMException("The operation was aborted", "AbortError");

    const errorFor = ({ errorCode, errorMessage } = {}) => {
        const message = errorMessage ?? `KeePassXC error ${errorCode}`;
        return INVALID_INPUT_ERRORS.includes(errorCode)
            ? new TypeError(message)
            : new DOMException(message, ERROR_NAMES[errorCode] ?? "NotAllowedError");
    };

    const isSameOriginWithAncestors = () =>
        Array.from(location.ancestorOrigins).every((origin) => origin === location.origin);

    const serve = (action, encode, options) => {
        const { publicKey, signal } = options;
        if (signal?.aborted) {
            throw abortError(signal);
        }
        if (!isSameOriginWithAncestors()) {
            throw new DOMException("Passkeys are unavailable in cross-origin frames", "NotAllowedError");
        }
        if (!isHookActive()) {
            throw new DOMException("The passkey hook is inactive", "NotAllowedError");
        }
        let answer = null;
        try {
            answer = callHook({ action, publicKey: encode(publicKey) });
            if (signal?.aborted) {
                throw abortError(signal);
            }
            if (answer?.publicKey) {
                return buildCredential(answer.publicKey);
            }
        } catch (error) {
            if (signal?.aborted) {
                throw error;
            }
            callHook({ action: "report" });
            console.error("qute-passkeys", error);
            throw new DOMException("The passkey script failed", "NotAllowedError");
        }
        throw errorFor(answer ?? undefined);
    };

    const pendingUntilAborted = (signal) =>
        new Promise((_, reject) => {
            if (signal?.aborted) {
                reject(abortError(signal));
            }
            signal?.addEventListener("abort", () => reject(abortError(signal)), { once: true });
        });

    const { create: nativeCreate, get: nativeGet } = CredentialsContainer.prototype;

    CredentialsContainer.prototype.create = async function create(options) {
        return options?.publicKey
            ? serve("passkeys-register", encodeCreationOptions, options)
            : nativeCreate.call(this, options);
    };

    CredentialsContainer.prototype.get = async function get(options) {
        if (!options?.publicKey) {
            return nativeGet.call(this, options);
        }
        switch (options.mediation) {
            case "silent":
                return null;
            case "conditional":
                return pendingUntilAborted(options.signal);
            default:
                return serve("passkeys-get", encodeRequestOptions, options);
        }
    };

    const staticMethods = {
        getClientCapabilities: async () => ({
            conditionalCreate: false,
            conditionalGet: false,
            hybridTransport: false,
            passkeyPlatformAuthenticator: true,
            userVerifyingPlatformAuthenticator: true,
        }),
        isConditionalMediationAvailable: async () => false,
        isUserVerifyingPlatformAuthenticatorAvailable: async () => true,
    };
    for (const [name, value] of Object.entries(staticMethods)) {
        Object.defineProperty(PublicKeyCredential, name, { configurable: true, value, writable: true });
    }
})();
