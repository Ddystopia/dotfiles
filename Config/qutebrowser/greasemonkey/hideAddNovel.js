// ==UserScript==
// @name         Hide ad 
// @version      1.0.1
// @author       Ddystopia
// @match        *://www.lightnovelpub.com/*
// ==/UserScript==

(() => {
  const head = document.querySelector('head');
  const style = document.createElement('style');
  style.innerHTML = `
    .adsbox {
      display: none;
    }
    `
  head.appendChild(style);
})()
