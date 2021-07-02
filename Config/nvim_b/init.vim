let $NEOVIM = "$HOME/.config/nvim"

function LoadConfig()
  exec "source $NEOVIM/plug.vim"
  exec "source $NEOVIM/settings.vim"
  exec "source $NEOVIM/maps.vim"

  for file in split(system("ls -p ".$NEOVIM."/conf"))
    exec "source $NEOVIM/conf/".file
  endfor
endfunction

call LoadConfig()
