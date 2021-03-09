ZSH_THEME="pi"
plugins=(
  git \
  fast-syntax-highlighting \
  vi-cursor \
  fzf \
  fzf-autocomplete \
  completion \
  history-substring-search \
  zsh-autosuggestions \
  spectrum \
)

autoload -U compinit
compinit

HISTSIZE=50000
SAVEHIST=50000

HISTFILE=$ZDOTDIR/.zsh_history 

eval $(thefuck --alias)

for file in $(ls -rA $ZDOTDIR/general); do
  source $ZDOTDIR/general/$file
done

