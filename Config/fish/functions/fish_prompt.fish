# function fish_prompt
#   printf " $(return_status) $(set_color blue)$PWD$(set_color normal)
# $(set_color magenta)❯$(set_color normal) "
# end

function fish_prompt
  set -l ret_status $(return_status)
  set -l pwd $(set_color blue)$(get_pwd)$(set_color normal)
  printf " $ret_status $pwd $(git_prompt_info)
$(set_color magenta)❯$(set_color normal) "
end

function get_pwd
  set -l git_root (git rev-parse --show-toplevel 2> /dev/null)
  if test -z $git_root
    set -e git_root
    set prompt_short_dir (string replace -r "^$HOME" "~" $PWD)
  else
    set parent (string replace --regex '[^/]+$' '' $git_root)
    set prompt_short_dir (string replace --regex "^$parent" '' $PWD)
  end
  echo $prompt_short_dir
end


function git_prompt_info
  git diff &> /dev/null
  set branch $(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if not test -z $branch
    printf "$(set_color green)$branch$(set_color normal)"
    if not git diff-index --quiet HEAD -- 2> /dev/null
      printf " $(set_color yellow)✗$(set_color normal)"
    end
  end
end


function get_lp
  set -l prettychars "δ∇θξσψήαβγɣεδζηθικλμνξοπρςστυφχψωϊϋόύώϐϑϒϓϔϕϖϗϙϙϛϛϝϝϟϟϡϡϣϥϧϧʂʃʄʅʆʇʈ∫∮∱√∀∁∂≡⋀⋁𝛗𝛙𝛇𝛄♥"
  set index (math $(od -A n -t u -N 2 /dev/random) % $(string length $prettychars) + 1 )
  string sub -s $index -l 1 $prettychars
end

function return_status 
  if test $status -eq 0
    printf "%s%s%s" (set_color -o green) (get_lp) (set_color normal)
  else
    printf "%s%s%s" (set_color -o red) (get_lp) (set_color normal)
  end
end
