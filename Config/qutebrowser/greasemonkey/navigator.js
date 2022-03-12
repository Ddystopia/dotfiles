// ==UserScript==
// @name         Rewrite globals
// @version      1.0.1
// @author       Ddystopia
// @match        *://*/*
// ==/UserScript==

(() => {
  const newNavigator = {
    platform: () => "Windows 10 NT",
    oscpu: () => "Windows 10 NT",
    hardwareConcurrency: () => 8,
    deviceMemory: () => 8,
    buildID: () => undefined,
    hid: () => undefined,
    language: () => "en-US",
    languages: () => Object.freeze(["en-US", "en"]),
    maxTouchPoints: () => 1,
    mediaSession: () => undefined,
    onLine: () => true,
    // productSub: () => "20030107",
    serial: () => undefined,
    vendor: () => "Google Inc.",
    webdriver: () => false,
  };
  const newWindow = {
    isClosed: () => false,
    devicePixelRatio: () => 1,
  };
  const newDocument = {
    referrer: () => "https://www.google.com/search?q=site",
  };

  redefine(window.navigator, newNavigator);
  redefine(document, newDocument);
  redefine(window, newWindow);


  function redefine(original, additional) {
    for (const [key, lambda] of Object.entries(additional)) {
      if (lambda() === undefined) {
        delete original[key];
      }
      Object.defineProperty(original, key, {
        get: () => lambda(),
        set: () => {},
      });
    }
  }
})();
