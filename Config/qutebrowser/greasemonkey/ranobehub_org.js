// ==UserScript==
// @name         lightpubnovel
// @version      1.0.1
// @author       Ddystopia
// @match        https://ranobehub.org/*
// ==/UserScript==

(() => {
  const style = document.createElement("style");
  style.textContent = `
    .ads-desktop {
      display: none !important;
    }
`;
  document.head.prepend(style);
})();
