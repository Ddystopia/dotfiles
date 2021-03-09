set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1
set fileformats=unix,dos,mac
filetype on
filetype plugin on
filetype plugin indent on
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
cmap w!! w !sudo tee %
