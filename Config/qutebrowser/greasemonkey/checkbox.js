// ==UserScript==
// @name         Style all checkboxes
// @version      0.1
// @description  Change the style of all checkboxes
// @include      https://github.com/*
// @grant        GM_addStyle
// ==/UserScript==

(function() {
    'use strict';

    GM_addStyle(`
        /* Hide the actual checkbox */
        input[type="checkbox"] {
            display: none;
        }

        /* Create a new checkbox look */
        input[type="checkbox"] + label {
            position: relative;
            padding-left: 25px;
            cursor: pointer;
        }

        /* Unchecked state */
        input[type="checkbox"] + label:before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            width: 16px;
            height: 16px;
            border: 3px solid #4d4f59;
            background: #222128;;
            border-radius: 2px;
            box-sizing: border-box;
        }

        /* Checked state */
        input[type="checkbox"]:checked + label:before {
            background: #4d4f59;
        }

        /* Checkmark */
        input[type="checkbox"]:checked + label:after {
            content: "";
            position: absolute;
            left: 5px;
            top: 2px;
            width: 4px;
            height: 7px;
            border-right: 2px solid #FFF;
            border-bottom: 2px solid #FFF;
            transform: rotate(45deg);
        }
    `);
    // find all checkboxes and add labels after them
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(cb => {
        if (!cb.id) {
            // if checkbox doesn't have an id, generate a unique one
            cb.id = 'cb_' + Math.random().toString(36).substr(2, 9);
        }
        const label = document.createElement('label');
        label.htmlFor = cb.id;
        cb.parentNode.insertBefore(label, cb.nextSibling);
    });
})();

