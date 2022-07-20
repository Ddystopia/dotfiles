#!/bin/bash

function get_lp() {
  local prettyChars="Δ∇ΘΞΣΨήαβγɣεδζηθικλμνξοπρςστυφχψωϊϋόύώϐϑϒϓϔϕϖϗϘϙϚϛϜϝϞϟϠϡϣϥϦϧʂʃʄʅʆʇʈ∫∮∱√∀∁∂≡⋀⋁𝛗𝛙𝛇𝛄♥"
  (( index = $(od -A n -t u -N 2 /dev/random)%${#prettyChars} ))  
  echo ${prettyChars[index + 1]}

  # echo $(random-uni-char 931 90)
}

function git_prompt_info() {
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch != "" ]]; then
    local res="%F{green}%B$branch%b%f"
    if ! $(git diff-index --quiet HEAD -- 2> /dev/null); then
      res+=" %F{yellow}✗%f"
    fi
    echo $res
  fi
}

# by shashankmehta (https://github.com/shashankmehta)
function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

function return_status { 
  echo " %B%(?.%F{green}$(get_lp)%f.%F{red}$(get_lp)%f)%b"
}

setopt PROMPT_SUBST
PROMPT='$(return_status) %F{blue}$(get_pwd)%f $(git_prompt_info)
%F{magenta}❯%f '

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
