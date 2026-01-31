if status is-interactive
    # Commands to run in interactive sessions can go here
  set fish_cursor_insert line
  set fish_greeting
  fish_config theme choose "Dracula Official"
  function fish_mode_prompt; end

  alias nano="nvim"
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
    # read files passed as args, ignore comments and blank lines
    for line in (cat $argv | sed -e 's/#.*$//' | grep -v '^[[:space:]]*$')
        # split possible multiple assignments on a single line separated by ;
        for assign in (string split ';' -- $line)
            set assign (string trim -- $assign)
            if test -z "$assign"
                continue
            end

            # Split on '='; preserve '=' inside the value by joining rest back
            set parts (string split '=' -- $assign)
            set key $parts[1]
            if test (count $parts) -gt 1
                if test (count $parts) -gt 2
                    set val (string join -- '=' $parts[2..-1])
                else
                    set val $parts[2]
                end
            else
                set val ''
            end

            # strip surrounding quotes (single & double) and trim
            set val (string trim -- $val)
            set val (string replace -r '^"(.*)"$' '$1' -- $val)
            set val (string replace -r "^'(.*)'\$" '$1' -- $val)
            set val (string trim -- $val)

            # export
            set -gx $key $val
            echo "Exported key $key = $val"
        end
    end
end

# I don't seem to use it
function y
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end

function source_env_file
    set -l env_file $argv[1]

    if test -f "$env_file"
        set -l content (cat "$env_file")

        for pair in (string split ';' -- $content)
          export $pair
        end
    else
        echo "Error: File '$env_file' not found."
        return 1
    end
end

