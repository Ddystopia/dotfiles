// ==UserScript==
// @name            Reset Default Background Color
// @author          Ddysotpia
// @version         1.0.1
// @match           *
// @compatible      Greasemonkey
// @run-at          document-start
// ==/UserScript==

(() => {
  setTimeout(() => {
    document.body.style.backgroundColor = 'white';
  }, 50);

})()
