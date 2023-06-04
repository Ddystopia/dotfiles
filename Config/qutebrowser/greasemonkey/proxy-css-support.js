// ==UserScript==
// @name            Proxy Css Support
// @author          Ddysotpia
// @version         1.0.1
// @match           *://internals.rust-lang.org/*
// @compatible      Greasemonkey
// @run-at          document-start
// ==/UserScript==

(() => {
  const originalSupports = CSS.supports;

  CSS.supports = function(...args) {
    if (args[0] === "aspect-ratio: 1") {
      return true;
    }

    return originalSupports(...args);
  };
})()
