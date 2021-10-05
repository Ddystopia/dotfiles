Format = function()
  Cmd "w"
  local formatCmds = {
    lua = 'lua-format --indent-width=2 --spaces-inside-table-braces -i',
    go = 'gofmt -w',
    javascript = 'prettier -w --loglevel error',
    typescript = 'prettier -w --loglevel error',
    javascriptreact = 'prettier -w --loglevel error',
    typescriptreact = 'prettier -w --loglevel error',
    html = 'prettier -w --loglevel error',
    xml = 'prettier -w --loglevel error',
    json = 'prettier -w --loglevel error',
    css = 'prettier -w --loglevel error',
    scss = 'prettier -w --loglevel error',
    cmake = 'cmake-format -i',
    c = 'clang-format -style=file -i',
    cpp = 'clang-format -style=file -i',
    markdown = 'prettier -w --prose-wrap always --loglevel error',
    python = 'black -q'
  }
  local command = formatCmds[vim.bo.filetype] or "sed -i -e 's/\\s\\+$//'"
  local f = io.popen(command..' "'.. vim.api.nvim_buf_get_name("%")..'" 2>&1')
  print(f:read('*all'))
  f:close()
  Cmd "let tmp = winsaveview()"
  Cmd "e!"
  Cmd "call winrestview(tmp)"
  Cmd "IndentBlanklineRefresh"
end

CloceBuffer = function()
  if vim.api.nvim_buf_get_name "%" == "" or #vim.fn.getbufinfo{buflisted = 1} < 2 then
    Cmd "q"
  end

  if not vim.bo.readonly then
    Cmd "w"
  end

  Cmd "bdelete"
end

ToggleWrap = function()
  if vim.wo.wrap then
    vim.wo.wrap = false
    vim.api.nvim_buf_del_keymap(0, 'n', 'j')
    vim.api.nvim_buf_del_keymap(0, 'n', 'k')
  else
    vim.wo.wrap = true
    BMap('n', 'j', 'gj')
    BMap('n', 'k', 'gk')
  end
end

ToggleConceal = function()
  vim.wo.conceallevel = math.abs(vim.wo.conceallevel - 2)
end

ToggleKeyMap = function()
  vim.bo.iminsert = math.abs(vim.bo.iminsert - 1)
end

ToggleRelNums = function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end

Map('i', '<C-v>', '<C-[>"+pa')

Map('n', '<A-l>', ':lua ToggleKeyMap()<CR>')
Map('i', '<A-l>', '<C-^>')

Map('n', '<leader>F', ':lua Format()<CR>')
Map('n', '<leader>pc', ':lua ToggleConceal()<CR>')
-- Map('n', '<leader>pw', ':lua ToggleWrap()<CR>')

Map('n', '<leader>pr', ':lua ToggleRelNums()<CR>')

Map('n', '<leader>', '<nop>')
Map('n', '<leader>y', '"+y')
Map('v', '<leader>y', '"+y')

Map('n', '<tab>', '<cmd>bn<cr>')
Map('n', '<s-tab>', '<cmd>bp<cr>')

Map('n', '<C-h>', '<cmd>bp<cr>')
Map('n', '<C-l>', '<cmd>bn<cr>')
Map('n', '<C-j>', '<cmd>tabn<cr>')
Map('n', '<C-k>', '<cmd>tabp<cr>')

Map('n', 'gF', ':e <cfile><cr>')

Map('n', '<leader>w', ':w!<cr>')
Map('n', '<leader>?', '<cmd>lua vim.opt.hls = not vim.opt.hls<cr>')
Map('n', '<leader>/', ':nohlsearch<cr>')
Map('n', 'Q', ':lua CloceBuffer()<cr>')
Map('n', '<leader>cd', ':cd %:h<cr>')
Map('n', '<leader>cp', ':let @+ = expand("%:p:h")<cr>')

Map('n', '>', '>>')
Map('n', '<', '<<')

Map('n', '<leader>vv', ':e $MYVIMRC<cr>')
Map('n', '<leader>vr', ':source $MYVIMRC<cr>:echo "Reloaded"<cr>')

Map('n', '<leader>ps', ':set spell!<cr>')
Map('n', '<leader>pl', ':set list!<cr>')

if vim.env.TMUX == nil then Map('n', '<A-a>', ':silent !$TERM & disown<cr>') end

Map('', '<A-w>', '<C-w>')
Map('t', '<A-a>', '<C-\\><C-n>')

Map('n', '\\\\', '<Esc>/<++><Enter>"_c4l')

Map('n', 'cd', ':cd ')

Cmd "inoremap <expr> <C-j>   pumvisible() ? '\\<C-n>' : '\\<C-j>'"
Cmd "inoremap <expr> <-k>   pumvisible() ? '\\<C-p>' : '\\<C-k>'"
Cmd "inoremap <expr> <Tab>   pumvisible() ? '\\<C-n>' : '\\<Tab>'"
Cmd "inoremap <expr> <S-Tab> pumvisible() ? '\\<C-p>' : '\\<S-Tab>'"
