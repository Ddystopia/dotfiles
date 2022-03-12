// ==UserScript==
// @name         YouTube Auto Skip Ads
// @version      1.0.1
// @description  Skip YouTube ads automatically
// @author       Ddystopia
// @match        *://*.youtube.com/*
// ==/UserScript==

// TODO: Mutation Observer

setInterval(() => {
  const ad = document.querySelector(".ad-showing");
  const btn = document.querySelector(
    ".ytp-ad-skip-button,.videoAdUiSkipButton"
  );

  if (btn) {
    btn.click();
  }

  document.querySelector("video").playbackRate = ad ? 10 : 1;
}, 50);
