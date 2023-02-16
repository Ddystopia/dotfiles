require "utils"

vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.foldenable = false
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 3
vim.cmd "au BufRead,BufNewFile *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4"

vim.opt.fileencoding = 'utf-8'

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamed'

vim.opt.spell = false
vim.opt.spelllang = 'en_us,ru_yo'
vim.opt.spellsuggest = "best,9"
vim.opt.iminsert = 0
vim.opt.imsearch = -1
-- vim.opt.keymap = 'russian-jcukenwin'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.showmode = false
vim.opt.signcolumn = 'no'
vim.opt.cursorline = true
vim.opt.cmdheight = 0
vim.opt.colorcolumn = '81'

vim.opt.list = true
vim.opt.listchars = { trail = '⋅' }

vim.opt.termguicolors = true

vim.g.vimsyn_embed = 'l'

vim.mapleader = ' '
vim.g.mapleader = ' '

vim.opt.guifont = "droidsansmono nerd font 11"

vim.g.netrw_fastbrowse = 0

vim.cmd [[
augroup SetFiletypes
  au!
  au BufReadPost,BufRead *.zsh,.zshrc set ft=sh
  au BufReadPost,BufRead *.fish set ft=fish
  au BufReadPost,BufRead *.conf,.env,.env.example set ft=config
  au BufReadPost,BufRead *.asm set ft=nasm
  au BufReadPost,BufRead .prettierrc set ft=json
  au BufReadPost,BufRead *.{rkt,rktl,rktd} set filetype=scheme
  " au BufReadPost,BufRead *.md set filetype=markdown
augroup END
]]

--[[
vim.cmd [[
augroup ChangeAlacrittyPadding
 au!
 au VimEnter * lua DecreasePadding()
 au VimLeavePre * lua IncreasePadding()
augroup END
]]
-- ]]

vim.cmd "command! W :w!"
