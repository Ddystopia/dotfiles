set number
set relativenumber
set nowrap
set conceallevel=0
set listchars=tab:▸\ ,eol:¬ 
set guifont="droidsansmono nerd font 11"
set cursorline
colorscheme desert

" For highlight
au BufNewFile,BufRead *.asm
      \ set ft=nasm

au BufNewFile,BufRead .prettierrc
      \ set ft=json

set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1
set fileformats=unix,dos,mac
filetype on
filetype plugin on
filetype plugin indent on
"syntax enable
syntax on

set hidden
set formatoptions-=cro
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set completeopt-=preview

" For PEP 8
au BufNewFile,BufRead *.py
      \ set tabstop=4
      \ softtabstop=4
      \ shiftwidth=4

set foldenable
set foldlevel=99
set foldmethod=indent
set ignorecase
set smartcase
set mouse=a

" Spell checking and Russian support
set nospell spelllang=en_us,ru_yo
set iminsert=0
set imsearch=-1

set ignorecase
set hls
set is

au BufRead,BufNewFile .env,.env.* set filetype=config
au BufReadPost,BufRead *.zsh,.zshrc set ft=sh
au BufReadPost,BufRead *.fish set ft=fish
au BufReadPost,BufRead *.conf,sxhkdrc set ft=config
au BufNewFile,BufRead *.asm set ft=nasm
au BufNewFile,BufRead .prettierrc set ft=json

cmap w!! w !sudo tee %

let mapleader = " "
let g:mapleader = " "

function CloseBuffer()
  if @% == "" && len(getbufinfo({'buflisted':1})) < 2
    :q
  endif

  if !&readonly 
    :w
  endif

  :bdelete
endfunction

function FormatFile()
  if index(['javascript', 'typescript', "css", "html", "vue","javascriptreact", "markdown", "yaml"], &ft) != -1
    :CocCommand prettier.formatFile
  elseif &ft == "rust"
    :RustFmt
  elseif &ft == "c" || &ft == "cpp"
    :ClangFormat
  else 
    normal gg=G``
  endif
endfunction

" remove ex mode
nmap Q <nop>

" reload config
nmap <leader>vr :call LoadConfig()<CR>:echo "Reloaded"<CR>

" format file
nmap <leader>F :call FormatFile()<CR>

" go to definition in new tab
nmap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" copy to global buffer
nmap <silent> <leader>y "+y
vmap <silent> <leader>y "+y

" Switch spell check
nmap <silent> <leader>ps :set spell!<CR>

" Close buffer
nmap <silent> <leader>w :call CloseBuffer()<CR>

" Remove search
nmap <silent> <leader>\ :noh<cr>

" Toggle visualize tabs and EOL
nmap <leader>pl :set list!<CR>
