// ==UserScript==
// @name        pdfjs polyfill
// @include     qute://pdfjs/*
// @run-at      document-start
// ==/UserScript==

// https://github.com/tc39/proposal-relative-indexing-method#polyfill
// https://github.com/qutebrowser/qutebrowser/commit/726d5e614b1f80c339084eba7d1c240bf467fa9b
(function () {
  function at(idx) {
    // ToInteger() abstract op
    let n = Math.trunc(idx) || 0;
    // Allow negative indexing from the end
    if (n < 0) {
      n += this.length;
    }
    // OOB access is guaranteed to return undefined
    if (n < 0 || n >= this.length) {
      return undefined;
    }
    // Otherwise, this is just normal property access
    return this[n];
  }

  const TypedArray = Reflect.getPrototypeOf(Int8Array);
  for (const type of [Array, String, TypedArray]) {
    Object.defineProperty(type.prototype, "at", {
      value: at,
      writable: true,
      enumerable: false,
      configurable: true,
    });
  }
})();

// We can't patch Array.at for Workers, so we just pretend we don't support
// them, as PDF.js works without them too.
unsafeWindow.Worker = undefined;

// https://github.com/mozilla/pdf.js/commit/7cc761a8c0ff12217ff8478bdb5a2fce3a07833a
unsafeWindow.structuredClone = function (object, transfers) {
  // https://youmightnotneed.com/lodash
  const isArrayBuffer = (value) => value.toString() === "[object ArrayBuffer]";

  // Trying to perform a structured clone close to the spec, including
  // transfers.
  function fallbackCloneValue(value) {
    if (
      typeof value === "function" ||
      typeof value === "symbol" ||
      value instanceof URL
    ) {
      throw new Error(
        `LoopbackPort.postMessage - cannot clone: ${value?.toString()}`
      );
    }

    if (typeof value !== "object" || value === null) {
      return value;
    }
    if (cloned.has(value)) {
      // already cloned the object
      return cloned.get(value);
    }
    let buffer, result;
    if ((buffer = value.buffer) && isArrayBuffer(buffer)) {
      // We found object with ArrayBuffer (typed array).
      if (transfers?.includes(buffer)) {
        result = new value.constructor(
          buffer,
          value.byteOffset,
          value.byteLength
        );
      } else {
        result = new value.constructor(value);
      }
      cloned.set(value, result);
      return result;
    }
    if (value instanceof Map) {
      result = new Map();
      cloned.set(value, result); // Adding to cache now for cyclic references.
      for (const [key, val] of value) {
        result.set(key, fallbackCloneValue(val));
      }
      return result;
    }
    if (value instanceof Set) {
      result = new Set();
      cloned.set(value, result); // Adding to cache now for cyclic references.
      for (const val of value) {
        result.add(fallbackCloneValue(val));
      }
      return result;
    }
    result = Array.isArray(value) ? [] : Object.create(null);
    cloned.set(value, result); // Adding to cache now for cyclic references.
    // Cloning all value and object properties, however ignoring properties
    // defined via getter.
    for (const i in value) {
      let desc,
        p = value;
      while (!(desc = Object.getOwnPropertyDescriptor(p, i))) {
        p = Object.getPrototypeOf(p);
      }
      if (typeof desc.value === "undefined") {
        continue;
      }
      if (typeof desc.value === "function" && !value.hasOwnProperty?.(i)) {
        continue;
      }
      result[i] = fallbackCloneValue(desc.value);
    }
    return result;
  }

  const cloned = new WeakMap();
  return fallbackCloneValue(object);
};
