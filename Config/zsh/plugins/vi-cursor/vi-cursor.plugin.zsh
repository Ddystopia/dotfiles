#!/bin/bash

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
      echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
        echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select

_fix_cursor() {
  echo -ne '\e[6 q'
}

precmd_functions+=(_fix_cursor)
