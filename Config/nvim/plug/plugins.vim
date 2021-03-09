function! DoRemote(arg)
	UpdateRemotePlugins
endfunction

" Plug
call plug#begin(stdpath('data') . '/plugged')
  Plug 'mhinz/vim-startify'
  Plug 'dracula/vim'

  Plug 'zxqfl/tabnine-vim'

  Plug 'puremourning/vimspector'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'ryanoasis/vim-devicons'

  " Plug 'majutsushi/tagbar'
  " Plug 'liuchengxu/vista.vim'
  " Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  " Plug 'reedes/vim-pencil'

  Plug 'rust-lang/rust.vim'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'tpope/vim-fugitive' 
  Plug 'tmhedberg/SimpylFold'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'

  Plug 'Shougo/context_filetype.vim'
  Plug 'tyru/caw.vim'

  " Plug 'marcweber/vim-addon-mw-utils'
  Plug 'scrooloose/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'rhysd/vim-clang-format'
  " Plug 'mg979/vim-visual-multi'
  Plug 'tpope/vim-surround'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'liuchengxu/vim-which-key'
  Plug 'metakirby5/codi.vim'
  Plug 'voldikss/vim-floaterm'

  Plug 'mattn/emmet-vim'
  Plug 'airblade/vim-rooter' 
  Plug 'lyokha/vim-xkbswitch'
  " Plug 'turbio/bracey.vim'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Yggdroot/indentLine'
  " Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    
call plug#end()
