require "utils"

vim.g.centered_cursor = false

vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.foldenable = false
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 3

vim.cmd [[
vnoremap <silent> @ :<C-u>execute "'<,'>" . 'normal! @' . getcharstr()<CR>
]]

AutoCommand("BufEnter", function()
  vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
end)

AutoCommand({ "BufRead", "BufNewFile" }, function(_)
  vim.cmd [[
    syntax match urlPattern /http[s]\?:\/\/[^\s'"]\+/ contains=@NoSpell
  ]]
end)

AutoCommand({ "BufRead", "BufNewFile" }, function(args)
  SetLocalOption(args.buf, 'tabstop', 4)
  SetLocalOption(args.buf, 'softtabstop', 4)
  SetLocalOption(args.buf, 'shiftwidth', 4)
end, {
  pattern = { "*.py", "*.rs" }
})

AutoCommand({ "BufRead", "BufNewFile" }, function(args)
  SetLocalOption(args.buf, 'tabstop', 2)
  SetLocalOption(args.buf, 'softtabstop', 2)
  SetLocalOption(args.buf, 'shiftwidth', 2)
end, {
  pattern = { "*.lua" }
})

AutoCommand({ "BufReadPost", "BufNewFile", "BufEnter" }, DisableSyntaxOnLargeFiles, {
  group = vim.api.nvim_create_augroup("DisableSyntaxOnLargeFiles", {}),
  desc = 'Disable syntax on large files'
})


vim.opt.fileencoding = 'utf-8'
vim.opt.updatetime = 750

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
vim.opt.colorcolumn = "81,101"

vim.opt.list = true
vim.opt.listchars = { trail = '⋅' }

vim.opt.termguicolors = true

vim.g.vimsyn_embed = 'l'

vim.mapleader = ' '
vim.g.mapleader = ' '

vim.opt.guifont = "droidsansmono nerd font 11"

vim.g.netrw_fastbrowse = 0
vim.g.netrw_browsex_viewer = os.getenv("BROWSER") or "qutebrowser"

local undodir = os.getenv("HOME") .. "/.local/cache/nvim/undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p", 0700)
end
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.filetype.add({
  extension = {
    typ = "typst",
    zsh = "sh",
    fish = "fish",
    conf = "config",
    asm = "nasm",
    h = "c",
    v = "coq",
    -- md = "markdown",
  },
  filename = {
    ['.zshrc'] = "sh",
    ['.env'] = "config",
    ['.env.example'] = "config",
    ['.prettierrc'] = "json"
    -- ['rkt'] = "scheme",
    -- ['rktl'] = "scheme",
    -- ['rktd'] = "scheme",
  }

})
