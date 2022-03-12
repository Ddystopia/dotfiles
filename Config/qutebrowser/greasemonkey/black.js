// ==UserScript==
// @name         Img to black
// @version      1.0.1
// @author       Ddystopia
// @match        *
// ==/UserScript==

(() => {
  return
  const head = document.querySelector('head');
  const style = document.createElement('style');
  style.innerHTML = `
    .jfk-bubble.gtx-bubble, 
    .captcheck_answer_label > input + img, 
    span#closed_text > img[src^="https://www.gstatic.com/images/branding/googlelogo"], 
    span[data-href^="https://www.hcaptcha.com/"] > #icon, #bit-notification-bar-iframe,
    ::-webkit-calendar-picker-indicator, img:not([src^="/_next/static/images/"])
    {
     filter: invert(100%) hue-rotate(180deg) contrast(95%) !important;
    }
    `
  head.appendChild(style);
})()
