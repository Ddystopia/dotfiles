let $NEOVIM = "$HOME/.config/nvim/"

function ImportFiles_CONFIG(dir)
  let files = split(system("ls -p " . expand(a:dir) . " | grep -v /"))
  let dirs = split(system("ls -p " . expand(a:dir) . " | grep /"))

  for file in files
    exec "source " . a:dir . "/" . file
  endfor

  if !empty(dirs)
    for dir in dirs
      call ImportFiles_CONFIG($NEOVIM.dir)
    endfor
  endif

endfunction

function LoadConfig_CONFIG()
  call ImportFiles_CONFIG($NEOVIM."plug")
  call ImportFiles_CONFIG($NEOVIM."general")
  call ImportFiles_CONFIG($NEOVIM."conf")
endfunction

call LoadConfig_CONFIG()
