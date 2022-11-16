// ==UserScript==
// @name         Ravesli dark theme
// @version      1.0.1
// @author       Ddystopia
// @match        https://ravesli.com/*
// @run-at document-start
// ==/UserScript==

(() => {
  const style = `
body {
  background: black;
  color: white !important;
}
p, h1, h2, h3, h4, h5, h6,
.czagvstat, li, a {
  color: white !important;
}
.toc_list ol .toc_item a,
.comment .fn, .reply a {
  color: #5c96d0;
  border-bottom-color: #5c96d0;
}
code, .prumitka, .toc, 
.gsc-control-cse, .gsc-input-box {
  background: black !important;
  border-color: black !important;
}
`;
  GM_addStyle(style);
})();

function GM_addStyle(cssStr) {
  const newNode = document.createElement("style");
  newNode.textContent = cssStr;

  let target = null;
  const f = () => {
    target =
      document.querySelector("head") ||
      document.body ||
      document.documentElement;
    if (!target) {
      setTimeout(f, 10);
    } else {
      target.appendChild(newNode);
    }
  };
  f();
}
