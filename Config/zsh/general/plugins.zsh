is_plugin() {
  local name=$1
  builtin test -f $ZDOTDIR/plugins/$name/$name.plugin.zsh ||
    builtin test -f $ZDOTDIR/plugins/$name/_$name
}

for plugin ($plugins); do
  if is_plugin $plugin; then
    source $ZDOTDIR/plugins/$plugin/${plugin}.plugin.zsh
  else
    echo "[zsh] plugin '$plugin' not found"
  fi
done


