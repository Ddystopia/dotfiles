# lsp & lint hack
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401

config: ConfigAPI = config  # type: ignore # noqa: F821
c: ConfigContainer = c  # type: ignore # noqa: F821

# with manually migrating the config file on qutebrowser upgrades. If
# you prefer, you can also configure qutebrowser using the
# :set/:bind/:config-* commands without having to write a config.py
# file.
#
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html


config.load_autoconfig()

import dracula.draw

dracula.draw.blood(c, {"spacing": {"vertical": 6, "horizontal": 8}})

# c.url.start_pages = "file:///home/nf/.config/qutebrowser/startpage/index.html"
# c.url.default_page = "file:///home/nf/.config/qutebrowser/startpage/index.html"

# Tor as proxy
# c.content.proxy = 'socks://localhost:9050'

# Save session
c.auto_save.session = True
c.auto_save.interval = 10_000

# Add blocking, depends of python-adblock
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://easylist-downloads.adblockplus.org/easylistdutch.txt",
    "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt",
    "https://www.i-dont-care-about-cookies.eu/abp/",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
]

# Dark mode yo
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "smart"

# Allow copy to clipboard
c.content.javascript.can_access_clipboard = True

# Allow pdfjs
c.content.pdfjs = True

# Remove downloads bar
c.downloads.remove_finished = 5_000

# No shit in stderr
c.logging.level.console = "critical"

# Spell check
# c.spellcheck.langulages = ['en_US', 'ru_Ru', 'sk_SK']

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}",
    "dark": "https://duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion/?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "g": "https://google.com/search?q={}",
    "y": "https://youtube.com/results?search_query={}",
    "a": "https://wiki.archlinux.org/index.php?search={}",
    "w": "https://www.wolframalpha.com/input/?i={}",
    "td": "https://dictionary.cambridge.org/dictionary/english/{}",
    "t": "https://www.deepl.com/translator#//ru/{}",
    # "t": "https://translate.google.com/?hl=ru&sl=en&tl=ru&text={}",
    "п": "https://www.deepl.com/translator#ru/en/{}",
    # "п": "https://translate.google.com/?hl=ru&sl=ru&tl=en&text={}",
    "ts": "https://slovnik.aktuality.sk/preklad/slovensko-rusky/?q={}",
    "sktv": "https://www.kvizy.eu/slovensky-jazyk/tvary-slova/{}",
    "yd": "https://yandex.ru/search/?text={}",
}

# Disable autoplay
c.content.autoplay = False

# fmt: off
# Ru keybindings fix-ish
c.bindings.key_mappings = {
    "Й": "Q", "й": "q", "Ц": "W", "ц": "w", "У": "E", "у": "e",
    "К": "R", "к": "r", "Е": "T", "е": "t", "Н": "Y", "н": "y",
    "Г": "U", "г": "u", "Ш": "I", "ш": "i", "Щ": "O", "щ": "o",
    "З": "P", "з": "p", "Х": "{", "х": "[", "Ъ": "}", "ъ": "]",
    "Ф": "A", "ф": "a", "І": "S", "і": "s", "Ы": "S", "ы": "s",
    "В": "D", "в": "d", "А": "F", "а": "f", "П": "G", "п": "g",
    "Р": "H", "р": "h", "О": "J", "о": "j", "Л": "K", "л": "k",
    "Д": "L", "д": "l", "Ж": ":", "ж": ";", "Э": '"', "э": "'",
    "Я": "Z", "я": "z", "Ч": "X", "ч": "x", "С": "C", "с": "c",
    "М": "V", "м": "v", "И": "B", "и": "b", "Т": "N", "т": "n",
    "Ь": "M", "ь": "m", "Б": "<", "б": ",", "Ю": ">", "ю": ".",
}
# fmt: on

# Bindings for normal mode
config.bind(
    "zyd", "spawn youtube-dl -o '~/Media/YouTube/%(title)s - %(uploader)s' {url}"
)
config.bind(
    "zym",
    "spawn youtube-dl --extract-audio --audio-quality 0 --audio-format mp3 --yes-playlist -i -o '~/Music/%(title)' {url}",
)
config.bind("zyf", "hint links spawn mpv --keep-open=yes {hint-url} --fs")
config.bind("zyy", "spawn mpv {url} --fs")

config.bind(
    "zx",
    "config-cycle statusbar.show always never;; config-cycle tabs.show multiple never",
)

config.bind(
    "<Ctrl-i>",
    "spawn -u qute-keepass -p ~/KeePassFiles/MainDatabase.kdbx",
    mode="insert",
)

config.bind("zp", "config-cycle content.private_browsing true false")

config.bind("zd", "download-open")

config.bind("zt", "set-cmd-text -s :tab-take")


# By default
config.set("content.cookies.accept", "all", "chrome-devtools://*")
config.set("content.cookies.accept", "all", "devtools://*")
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 (Windows NT 10.0; rv:94.0) Gecko/20100101 Firefox/94.0",
)
# config.set(
#     "content.headers.user_agent",
#     "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}",
#     "https://web.whatsapp.com/",
# )
# config.set(
#     "content.headers.user_agent",
#     "Mozilla/5.0 ({os_info}; rv:94.0) Gecko/20100101 Firefox/94.0",
#     "https://accounts.google.com/*",
# )
# config.set(
#     "content.headers.user_agent",
#     "Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36",
#     "https://*.slack.com/*",
# )
# config.set(
#     "content.headers.user_agent",
#     "Mozilla/5.0 ({os_info}; rv:94.0) Gecko/20100101 Firefox/94.0",
#     "https://docs.google.com/*",
# )
# config.set(
#     "content.headers.user_agent",
#     "Mozilla/5.0 ({os_info}; rv:94.0) Gecko/20100101 Firefox/94.0",
#     "https://drive.google.com/*",
# )
config.set("content.images", True, "chrome-devtools://*")
config.set("content.images", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome-devtools://*")
config.set("content.javascript.enabled", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome://*/*")
config.set("content.javascript.enabled", True, "qute://*/*")
