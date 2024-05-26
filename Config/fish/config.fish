if status is-interactive
    # Commands to run in interactive sessions can go here
  set fish_cursor_insert line
  set fish_greeting
  fish_config theme choose "Dracula Official"
  function fish_mode_prompt; end

  alias tk="go-task"
  alias e="exa -abF --group-directories-first --icons"
  alias ex="exa -abF --group-directories-first --icons -lTL 1 --no-time --git --no-user"
  alias gc="git add -A && git commit -m "
  alias ls="ls --color -L"
# alias la="ls -AlhL"
# alias l="ls -AL"
  alias la="ex"
  alias l="e"
  alias h="history 1 | grep"
  alias emacs="emacs -nw"
  alias rm="rm -rf"
  alias cp="cp -r"
  alias pacman="sudo pacman"
  alias zathura="zathura --mode fullscreen"
  alias nv="nvim"
  alias make="make -j$(nproc)"
  alias ip='ip --color=auto'
  alias myip='curl -Z ifconfig.me; echo ""' 
  alias myip4='dig @resolver4.opendns.com myip.opendns.com +short -4'
  alias myip6='dig @ns1.google.com TXT o-o.myaddr.l.google.com +short -6'
  alias ..="cd .."
  alias ...="cd ../.."
  alias ....="cd ../../.."
  alias .....="cd ../../../.."

  alias russ="russ -d $XDG_CONFIG_HOME/russ/feeds.db"

  function last_history_item; echo $history[1]; end
  abbr -a !! --position anywhere --function last_history_item

  zoxide init --cmd cd fish | source
end

if test -f ~/.profile
  bash -c 'source ~/.profile'
else
  touch ~/NO_PROFILE
end

# thefuck --alias | source

function envsource
    set -f envfile "$argv"
    if not test -f "$envfile"
        echo "Unable to load $envfile"
        return 1
    end
    while read line
        if not string match -qr '^#|^$' "$line" # skip empty lines and comments
            if string match -qr '=' "$line" # if `=` in line assume we are setting variable.
                set item (string split -m 1 '=' $line)
                set item[2] (eval echo $item[2]) # expand any variables in the value
                set -gx $item[1] $item[2]
                echo "Exported key: $item[1]" # could say with $item[2] but that might be a secret
            else
                eval $line # allow for simple commands to be run e.g. cd dir/mamba activate env
            end
        end
    end < "$envfile"
end
