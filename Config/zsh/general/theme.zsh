if [[ -f "$ZDOTDIR/themes/$ZSH_THEME.zsh-theme" ]]; then
  source "$ZDOTDIR/themes/$ZSH_THEME.zsh-theme"
else
  echo "[zsh] theme '$ZSH_THEME' not found"
fi

