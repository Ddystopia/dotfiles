# shopt -s autocd

set -o vi
ZSH_THEME="pi"
plugins=(
  fast-syntax-highlighting \
  vi-cursor \
  # fzf \
  # fzf-autocomplete \
  completion \
  # history-substring-search \
  zsh-autosuggestions \
  spectrum \
)

setopt HIST_IGNORE_SPACE
HISTSIZE=5000000
SAVEHIST=5000000

autoload -U compinit
if [[ -n `find -L $ZDOTDIR -maxdepth 1 -iname '.zcompdump*' -mtime 1` ]]; then
  compinit;
else
  compinit -C;
fi;

HISTFILE=$ZDOTDIR/.zsh_history 
TIMEFMT=$'\nCPU\t%P\ntotal\t%*E\nuser\t%*U\nsystem\t%*S'
# eval $(thefuck --alias)

for file in $(ls -rA $ZDOTDIR/general); do
  source $ZDOTDIR/general/$file
done

