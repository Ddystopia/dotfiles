set number
set relativenumber
set nowrap
set conceallevel=0
set listchars=tab:▸\ ,eol:¬ 
" set cc=81 " set color column
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if (has("termguicolors"))
  set termguicolors
endif
set guifont="droidsansmono nerd font 11"
colorscheme dracula
 
" For highlight
au BufNewFile,BufRead *.asm
      \ set ft=nasm

au BufNewFile,BufRead .prettierrc
      \ set ft=json
  

