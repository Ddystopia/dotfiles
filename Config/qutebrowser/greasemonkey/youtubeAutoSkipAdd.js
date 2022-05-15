// ==UserScript==
// @name         YouTube Auto Skip Ads
// @version      1.0.1
// @description  Skip YouTube ads automatically
// @author       Ddystopia
// @match        *://*.youtube.com/*
// ==/UserScript==

// TODO: Mutation Observer

setInterval(() => {
  const ad = () => document.querySelector(".ad-showing");
  const skipButton = document.querySelector(
    ".ytp-ad-skip-button,.videoAdUiSkipButton"
  );

  if (skipButton) {
    skipButton.click();
  }

  if (ad()) {
    document.querySelectorAll("video").forEach((v) => (v.playbackRate = 16));
    const canselRateInterval = setInterval(() => {
      if (ad()) {
        clearInterval(canselRateInterval);
        document.querySelectorAll("video").forEach((v) => (v.playbackRate = 1));
      }
    }, 5);
  }
}, 50);
