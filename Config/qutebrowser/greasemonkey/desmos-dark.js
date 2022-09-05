// ==UserScript==
// @name         Desmos dark theme
// @version      1.0.1
// @author       Ddystopia
// @match        https://www.desmos.com/*
// @run-at document-start
// ==/UserScript==

GM_addStyle(`
  .dcg-exppanel
  {
    background: rgb(35,35,35) !important;
  }

  .dcg-calculator-api-container #graph-container .dcg-container
  {
    font-size: 100%;
    color: #ddd !important;
    background: rgb(30,30,30) !important;
  }

  .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem
  {
    border-top: 1px solid rgba(20,20,20);
  }

  .dcg-calculator-api-container .dcg-container .dcg-expression-top-bar
  {
    background: linear-gradient(#3a3a3a, #303030);
  }

  .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem .dcg-tab
  {
    background: rgba(0,0,0,0.2);
    border-right: 1px solid rgba(0,0,0,0.2);
  }

  .dcg-calculator-api-container .dcg-container .dcg-mq-editable-field:not(.dcg-no-fadeout):after
  {
    background: linear-gradient(to right, rgba(35,35,35,0), rgb(35,35,35));
  }

  .dcg-calculator-api-container .dcg-expressionitem.dcg-expressiontable .dcg-table-container:after
  {
    background: linear-gradient(to right, rgba(35,35,35,0), rgb(35,35,35));
  }

  .dcg-calculator-api-container .dcg-expressionitem.dcg-expressiontable .dcg-table-container:before
  {
    background: linear-gradient(to left, rgba(35,35,35,0), rgb(35,35,35));
  }

  .dcg-calculator-api-container .dcg-expressionitem.dcg-new-expression .dcg-new-math-div .dcg-new-expression-fade
  {
    background: linear-gradient(to top, rgb(35,35,35), rgba(35,35,35,0) 50%);
  }

  .dcg-calculator-api-container .dcg-expressionitem.dcg-expressiontable .dcg-tabledata:not(.dcg-focus-in-bottom-row):before
  {
    background: linear-gradient(to top, rgb(35,35,35), rgba(35,35,35,0));
  }

  .dcg-calculator-api-container .dcg-expressionitem.dcg-expressiontable .dcg-tabledata:not(.dcg-focus-in-right-column):after
  {
    background: linear-gradient(to left, rgb(35,35,35), rgba(35,35,35,0));
  }

  .dcg-calculator-api-container .dcg-expression-edit-actions .dcg-graphic
  {
    background: linear-gradient(to right, rgba(35,35,35,0), rgb(35,35,35));
  }

  .dcg-calculator-api-container .dcg-container .dcg-mq-editable-field:not(.dcg-no-fadeout) .dcg-mq-root-block.dcg-mq-editing-overflow-left:before
  {
    background: linear-gradient(to left, rgba(35,35,35,0), rgb(35,35,35));
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container input
  {
    background-color: #202020;
    color: #eee;
    border: 1px solid #101010;
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container input.dcg-hovered
  {
    background-color: #191919;
    color: #fff;
    box-shadow: 0 1px #101010;
  }

  .dcg-calculator-api-container .dcg-mq-underline-container .dcg-math-field
  {
    border-bottom: 1px solid rgba(0,0,0,0.8);
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container input:focus:not([disabled])
  {
    border-color: rgb(71,129,185);
    -webkit-box-shadow: 0 1px rgb(71,129,185);
    box-shadow: 0 1px rgb(71,129,185);
  }

  .dcg-calculator-api-container .dcg-mq-underline-container .dcg-math-field.dcg-focus, .dcg-calculator-api-container .dcg-mq-underline-container .dcg-math-field.dcg-invalid
  {
    border-bottom: 2px solid rgb(71,129,185);
    margin-bottom: 0;
  }

  .dcg-calculator-api-container .dcg-mq-underline-container .dcg-math-field.dcg-invalid
  {
    border-bottom: 2px solid #981d1b;
  }

  .dcg-calculator-api-container .dcg-tooltipped-error
  {
    color: #ac5239;
  }

  .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem.dcg-selected .dcg-tab, .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem.dcg-dragging .dcg-tab
  {
    background: rgb(71,129,185);
  }

  .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem.dcg-selected, .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem.dcg-dragging
  {
    border-color: rgb(71,129,185);
    border-right: 1px solid rgb(71,129,185);
  }

  .dcg-calculator-api-container .dcg-popover .dcg-popover-interior
  {
    background-color: #2a2a2a;
  }

  .dcg-calculator-api-container .dcg-popover.dcg-bottom .dcg-arrow
  {
    background-color: rgb(35,35,35) !important;
  }

  .dcg-calculator-api-container .dcg-expression-edit-actions
  {
    background-color: rgb(35,35,35) !important;
  }

  .dcg-calculator-api-container .dcg-evaluation-container .dcg-evaluation .dcg-mathquill-wrapper .dcg-typeset-math
  {
    border: 1px solid rgba(20,20,20,0.8);
    background: rgba(0,0,0,0.1);
    color: #888;
  }

  .dcg-calculator-api-container .dcg-btn-flat-gray
  {
    background: #3a3a3a !important;
    text-shadow: 1px 1px #000;
  }

  .dcg-action-zoomin, .dcg-action-zoomout
  {
    background-color: #3a3a3a !important;
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container .dcg-checkbox .dcg-checkbox-box .dcg-icon-check,
.dcg-calculator-api-container .dcg-component-checkbox .dcg-checkbox i
  {
    text-shadow: -1px -1px 0 rgba(71,129,185,0.2), 1px -1px 0 rgba(71,129,185,0.2), -1px 1px 0 rgba(71,129,185,0.2), 1px 1px 0 rgba(71,129,185,0.2);
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container .dcg-checkbox .dcg-checkbox-box
  {
    color: rgb(71,129,185) !important;
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container .dcg-checkbox.dcg-depressed .dcg-checkbox-box .dcg-icon-check,
.dcg-calculator-api-container .dcg-component-checkbox.dcg-green.dcg-checked .dcg-checkbox i
  {
    color: rgb(71,129,185) !important;
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container .dcg-checkbox.dcg-hovered .dcg-checkbox-box:not(.dcg-checked) .dcg-icon-check,
.dcg-calculator-api-container .dcg-component-checkbox.dcg-hovered:not(.dcg-checked) .dcg-checkbox i
  {
    color: rgb(71,129,185,0.3) !important;
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container.dcg-label-visible .dcg-checkbox
  {
    color: #888 !important;
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container .dcg-checkbox
  {
    color: #787878 !important;
  }

  .dcg-calculator-api-container .dcg-container .dcg-label-container .dcg-checkbox.dcg-hovered
  {
    color: #777 !important;
  }

  .dcg-calculator-api-container .dcg-popover .dcg-popover-interior
  {
    background-color: rgb(35,35,35) !important;
  }

  .dcg-calculator-api-container .dcg-options-menu
  {
    background-color: rgb(35,35,35);
    border: 1px solid #000;
  }

  .dcg-calculator-api-container .dcg-expressions-options-menu .dcg-options-menu-section:not(:first-of-type), .dcg-calculator-api-container .dcg-table-column-menu .dcg-options-menu-section:not(:first-of-type)
  {
    border-top: 1px solid #000;
  }

  .dcg-calculator-api-container .dcg-create-sliders .dcg-msg
  {
    color: rgba(255,255,255,0.6);
  }

  .dcg-calculator-api-container .dcg-settings-container .dcg-minor-checkbox, .dcg-calculator-api-container .dcg-settings-container .dcg-step-label
  {
    color: #ddd;
  }

  .dcg-calculator-api-container .dcg-options-menu .dcg-component-checkbox .dcg-checkbox-children
  {
    color: #ddd;
  }

  .dcg-calculator-api-container .dcg-expressions-options-menu .dcg-options-menu-section .dcg-options-menu-section-title, .dcg-calculator-api-container .dcg-table-column-menu .dcg-options-menu-section .dcg-options-menu-section-title
  {
    color: #888;
  }

  .dcg-calculator-api-container .dcg-btn-blue
  {
    background: rgb(71,129,185);
  }

  .dcg-calculator-api-container .dcg-container .dcg-clickable-info-container .dcg-clickable-property-row .dcg-remove-rule
  {
    background: #444;
  }

  .dcg-expressionlist .dcg-mq-root-block
  {
    color: #ddd;
  }

  .dcg-calculator-api-container .dcg-settings-container .dcg-segmented-control-container .dcg-segmented-control-btn.dcg-hovered:not(.dcg-selected)
  {
    color: #555;
  }

  .dcg-calculator-api-container .dcg-circular-icon.dcg-thick-outline
  {
    border: 2px solid #fff;
    color: #fff;
  }

  .dcg-calculator-api-container .dcg-expression-footer-title
  {
    color: rgba(255,255,255,0.5);
  }

  .dcg-calculator-api-container .dcg-smart-textarea-container textarea.dcg-smart-textarea, .dcg-calculator-api-container .dcg-smart-textarea-container .dcg-displayTextarea
  {
    color: #ddd;
  }

  .dcg-calculator-api-container .dcg-sliding-interior
  {
    background-color: #222;
  }

  .dcg-calculator-api-container .dcg-expressionitem.dcg-expressionimage .dcg-image-input-grid
  {
    color: rgba(255,255,255,0.5);
  }

  .dcg-calculator-api-container .dcg-slider-interior .dcg-track .dcg-ticks .dcg-tick
  {
    background-color: #000;
  }

  .dcg-calculator-api-container .dcg-slider-interior .dcg-track .dcg-graphic
  {
    background-color: rgba(0,0,0,0.3);
  }

  .dcg-calculator-api-container .dcg-poi-label.dcg-has-outline .dcg-label
  {
    text-shadow: -1px -1px 0 #111, -1px 1px 0 #111, 1px -1px 0 #111, 1px 1px 0 #111, 0 -1px 0 #111, 0 1px 0 #111, 1px 0 0 #111, -1px 0 0 #111;
  }

  .desmodder-plugin-title-bar
  {
    color: #ddd;
  }

  .dcg-calculator-api-container .dcg-mq-math-mode .dcg-mq-selection, .dcg-calculator-api-container .dcg-mq-editable-field .dcg-mq-selection, .dcg-calculator-api-container .dcg-mq-math-mode .dcg-mq-selection .dcg-mq-non-leaf, .dcg-calculator-api-container .dcg-mq-editable-field .dcg-mq-selection .dcg-mq-non-leaf, .dcg-calculator-api-container .dcg-mq-math-mode .dcg-mq-selection .dcg-mq-scaled, .dcg-calculator-api-container .dcg-mq-editable-field .dcg-mq-selection .dcg-mq-scaled
  {
    background: #435870 !important;
  }

  .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem .dcg-tab
  {
    color: rgba(255,255,255,0.5);
  }

  .dcg-calculator-api-container .dcg-popover.dcg-bottom .dcg-arrow
  {
    border-bottom-color: rgb(35,35,35);
  }

  .dcg-calculator-api-container .dcg-expressions-options-menu .dcg-triangle:before, .dcg-calculator-api-container .dcg-slider-options-view .dcg-triangle:before
  {
    border-color: transparent rgb(35,35,35) transparent transparent;
  }

  .dcg-calculator-api-container .dcg-expressions-options-menu .dcg-triangle, .dcg-calculator-api-container .dcg-slider-options-view .dcg-triangle
  {
    border-color: transparent #444 transparent transparent;
  }

  .dcg-calculator-api-container .dcg-popover.dcg-left .dcg-arrow
  {
    border-left-color: rgb(35,35,35);
  }

  .dcg-calculator-api-container .dcg-keypad .dcg-keys-background
  {
    background: #333 !important;
  }

  .dcg-calculator-api-container .dcg-basic-keypad .dcg-keypad-btn-container .dcg-keypad-btn.dcg-btn-dark-on-gray
  {
    border: 1px solid #444;
  }

  .dcg-calculator-api-container .dcg-btn-light-gray
  {
    background: linear-gradient(#3a3a3a, #303030);
  }

  .dcg-calculator-api-container .dcg-basic-keypad .dcg-keypad-btn-container .dcg-keypad-btn.dcg-btn-light-on-gray
  {
    background: linear-gradient(rgba(0,0,0,0.2), rgba(0,0,0,0.4));
    border: 1px solid #444;
  }

  .dcg-calculator-api-container .dcg-keypad .dcg-functions-popover .dcg-popover-header .dcg-heading
  {
    color: #666;
  }

  .dcg-calculator-api-container .dcg-keypad .dcg-functions-popover .dcg-popover-header .dcg-heading.dcg-hovered
  {
    color: #ddd;
  }

  .dcg-calculator-api-container .dcg-drag-container .dcg-expressionitem
  {
    background: #222;
  }

  .dcg-calculator-api-container .dcg-toggle-view .dcg-toggle-switch
  {
    background: #555;
  }

  .dcg-calculator-api-container .dcg-toggle-view
  {
    background: #444;
  }

  .dcg-calculator-api-container .dcg-toggle-view.dcg-toggled .dcg-toggle-switch
  {
    background: #999;
  }

  .dcg-calculator-api-container .dcg-settings-container .dcg-visual-settings
  {
    border-bottom: 1px solid rgb(20,20,20);
  }

  .dcg-calculator-api-container .dcg-settings-container .dcg-axes-settings-container, .dcg-calculator-api-container .dcg-settings-container .dcg-radiangroup
  {
    border-top: 1px solid rgb(20,20,20);
  }

  .dcg-calculator-api-container .dcg-settings-container .dcg-axes-settings-container .dcg-checkbox-title .dcg-axis-label
  {
    background: #191919;
    color: #eeeeee;
  }

  .dcg-calculator-api-container .dcg-exppanel .dcg-expressionitem.dcg-inFolder .dcg-fade-container:after
  {
    border-left: 1px solid rgba(255,255,255,0.2);
  }
    `);

function GM_addStyle(cssStr) {
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
