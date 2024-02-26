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
alias ~="cd $HOME"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

