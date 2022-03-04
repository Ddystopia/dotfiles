is_plugin() {
  local name=$1
  local base=$ZDOTDIR/plugins/$name
  [[ -f $base/$name.plugin.zsh ]] || [[ -f $base/_$name ]]
}

for plugin ($plugins); do
  if is_plugin $plugin; then
    source $ZDOTDIR/plugins/$plugin/${plugin}.plugin.zsh
  else
    echo "[zsh] plugin '$plugin' not found"
  fi
done

