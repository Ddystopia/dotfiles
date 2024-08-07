// ==UserScript==
// @name         Deepl dark theme
// @version      1.0.1
// @author       Ddystopia
// @match        https://www.deepl.com/*
// @run-at document-start
// ==/UserScript==

GM_addStyle(`
   :root {
        color-scheme: dark;
        --color-accent: rgb(18, 143, 231);
        --color-accent-light: rgb(33, 154, 233);
        --color-accent-alternate: rgb(137, 234, 80);
        --color-dark: rgb(80, 80, 80);
        --color-darker: rgb(60, 60, 60);
        --color-darkest: rgb(30, 30, 30);
        --color-light: rgb(210, 210, 210);
        --color-lighter: rgb(240, 240, 240);
        --color-lightest: rgb(250, 250, 250);
        --color-medium: rgb(120, 120, 120);
    }

    svg,
    svg path {
        stroke: var(--color-accent) !important;
    }

    html {
        background: var(--color-darker) !important;
    }

    html:not(.lmt_df-1641_increase_mobile_breakpoint) .lmt__dict .lmt__dict__inner,
    .lmt__dict__inner * {
        background: var(--color-darker) !important;
        color: var(--color-light) !important;
    }

    header *,
    header::before,
    .lmt__language_container,
    .dl_body--redesign .lmt--web .lmt__textarea_container {
        background: var(--color-darker) !important;
        color: var(--color-light) !important;
        border-color: var(--color-darker) !important;
    }


    .dl_translator_page_container {
        background: var(--color-darkest);
    }

    .lmt__language_select__active__title,
    .lmt__language_select__active__title a {
        color: var(--color-light) !important;
    }

    .dl_pro__banner--featureWrapper *,
    .dl_app_ad *,
    .dl_top_element *,
    .dl_top_element--wide *,
    .dl_header *,
    .integratedLanguageSelectors .lmt--web .lmt__sides_container .lmt__side_container--target .lmt__language_container_switch,
    .lmt__textarea_separator,
    .lmt__textarea_separator__vertical_line {
        background: var(--color-darker) !important;
    }

    .lmt__docTrans-tab-container,
    .switch_module_switch__559c384a,
    .switch_module_size_medium__559c384a {
        background: rgba(0, 0, 0, 0);
    }

    .lmt__language_select__menu {
        color: var(--color-light) !important;
    }


    .lmt__translations_as_text__item *,
    .lmt__language_select__menu * {
        color: var(--color-light) !important;
    }

    .integratedLanguageSelectors .lmt--web .lmt__sides_container .lmt__side_container--target .lmt__language_container_switch,
    .lmt__textarea_container--text_too_long {
        border-color: var(--color-medium) !important;
    }

    button strong {
        color: var(--color-accent-light) !important;
    }

    .lmt__language_select__menu button:hover {
        background-color: var(--color-dark) !important;
    }

    textarea {
        color: var(--color-light) !important;
        border: none !important;
        background: var(--color-darkst) !important;
    }
`)

function GM_addStyle(cssStr) {
  return
  const newNode = document.createElement("style");
  newNode.textContent = cssStr;

  let target = null;
  const f = () => {
    target = document.querySelector("head") || document.body || document.documentElement;
    if (!target) {
      setTimeout(f, 10);
    } else {
      target.appendChild(newNode);
    }
  };
  f();
}
