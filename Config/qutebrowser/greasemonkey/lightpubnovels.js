// ==UserScript==
// @name         lightpubnovel
// @version      1.0.1
// @author       Ddystopia
// @match        https://www.lightnovelpub.com/*
// ==/UserScript==

(() => {
  document.body.innerHTML = document.body.innerHTML
    .replace(/<\/p><p>(?![^\w\d\s])/g, "")
    .replaceAll(String.fromCharCode(0x200c), "")
    .replace(/<p><\/p>/g, "");


  document.querySelectorAll(".desk-sml").forEach((e) => e.remove());
  const style = document.createElement("style");
  style.textContent = `
    * {
       user-select: text
    }
`;
  document.head.prepend(style);
  // document.cookie = document.cookie.replace(
  //   /googtrans=null/g,
  //   "googtrans=/en/ru"
  // );
})();
