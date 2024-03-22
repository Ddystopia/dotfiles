require('utils')

--- @param lsp boolean | nil Default value: true
function Format(lsp)
  if lsp == nil then lsp = true end

  local prettier_query = 'prettier -w --loglevel error '

  -- prettier args = { '', '--stdin-filepath', '"%:p"' },
  local formatCmds = {
    markdown = prettier_query .. "--prose-wrap always",
    rust = 'cargo fmt',
    lua = 'lua-format --indent-width=4 --spaces-inside-table-braces -i --column-limit=95',
    c = 'clang-format -stylefile -i',
    zig = 'zig fmt',
    go = 'gofmt -w',
    python = 'black -q',
    cpp = 'clang-format -stylefile -i',
    javascript = prettier_query,
    typescript = prettier_query,
    javascriptreact = prettier_query,
    typescriptreact = prettier_query,
    html = prettier_query,
    xml = prettier_query,
    json = prettier_query,
    css = prettier_query,
    scss = prettier_query,
    cmake = 'cmake-format -i',
    typst = "typstfmt"
  }

  -- local function feedkeys(keys, mode)
  --   local cmd = vim.api.nvim_replace_termcodes(keys, true, false, true);
  --   vim.api.nvim_feedkeys(cmd, mode, true)
  -- end
  --
  -- local function lsp_format_v()
  --   feedkeys([[:<C-U>silent \'<,\'>lua vim.lsp.format({
  --     filter = function (c) return c.name ~= "copilot" end
  --   })<CR>]], 'n')
  -- end

  if vim.bo.filetype == "typst" or vim.bo.filetype == "markdown" then
    lsp = false
  end

  if lsp == false then
    vim.cmd "w"
    -- TODO: stdin
    local command = formatCmds[vim.bo.filetype] or "sed -i -e 's/\\s\\+$//'"
    local f = io.popen(command .. ' "' .. vim.fn.expand("%") .. '" 3>&1 1>&3 2>&3')
    if f then
      print(f:read('*all'))
      f:close()
    end
  end

  if lsp == true then
    vim.lsp.buf.format()
    vim.cmd "w"
  end

  vim.cmd [[
    mkview
    e!
    loadview
  ]]
end

function ToggleWrap()
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

function ToggleCenteredScroll()
  if vim.g.centered_cursor then
    vim.api.nvim_del_keymap('n', 'j')
    vim.api.nvim_del_keymap('n', 'k')
    vim.g.centered_cursor = false
  else
    Map('n', 'j', 'jzz')
    Map('n', 'k', 'kzz')
    vim.g.centered_cursor = true
  end
end

-- TODO: not work
function QuitNetrw()
  for i = 1, vim.fn.bufnr('$') do
    if vim.api.nvim_buf_is_loaded(i) and
        vim.api.nvim_buf_get_option(i, 'filetype') == 'netrw' then
      vim.api.nvim_buf_delete(i, { force = true })
    end
  end
end

function StartTerminal()
  local cmd = 'cd ' .. vim.fn.expand('%:p:h') .. ' && $SHELL'
  local terminal_cmd = '$TERM -e sh -c \'' .. cmd .. '\''
  os.execute(terminal_cmd .. ' &')
end

-- vim.api.nvim_create_autocmd("VimLeavePre", { callback = QuitNetrw })

Map('n', '<leader>F', Format)

vim.cmd 'command! -nargs=* -complete=file E :silent !$TERM -e sh -c "cd `pwd`; nvim <args>"'

vim.cmd("command! T lua StartTerminal()")

vim.cmd "command! W :w!"

Map('i', '<C-v>', '<C-r>+')

Map('n', '<A-l>', function() vim.bo.iminsert = math.abs(vim.bo.iminsert - 1) end)
Map('i', '<A-l>', '<C-^>')

-- Map('n', '<leader>F', Format)
Map('v', '<leader>c', "!column -t -l2 -s= -o=<cr>")

Map('n', '<leader>pw', ToggleWrap)
-- Map('n', '<leader>sc',
--     function() vim.wo.conceallevel = math.abs(vim.wo.conceallevel - 2) end)

Map('n', '<leader>pr',
  function() vim.wo.relativenumber = not vim.wo.relativenumber end)

Map('n', '<leader>', '<nop>')
Map('n', '<leader>y', '"+y')
Map('v', '<leader>y', '"+y')
Map('n', '<leader>p', '"+p')
Map('v', '<leader>p', '"+p')

-- Vertical movements u/d half page
Map('n', '<C-u>', '<C-u>zz');
Map('n', '<C-d>', '<C-d>zz');

Map('n', 'n', 'nzz');
Map('n', 'N', 'Nzz');

Map('n', 'U', '<C-r>');

-- Map('n', 'w', 'vw');
-- Map('n', 'W', 'vW');
-- Map('n', 'b', 'vb');
-- Map('n', 'B', 'vB');
-- Map('n', 'e', 've');
-- Map('n', 'E', 'vE');

-- Map('n', 'j', 'jzz');
-- Map('n', 'k', 'kzz');

Map('n', 'gF', ':e <cfile><cr>')

Map('n', '<leader>w', ':w!<cr>')
Map('n', '<leader>?', function() vim.opt.hls = not vim.opt.hls end)
Map('n', '<leader>/', ':nohlsearch<cr>')
Map('n', '<leader>,', ':nohlsearch<cr>')
Map('n', 'Q', '@q')
Map('n', '<leader>cd', ':cd %:h<cr>')
Map('n', '<leader>cp', ':let @+ = expand("%:p:h")<cr>')

Map('c', 'w!!', '!sudo tee %')
Map('n', '>', '>>')
Map('n', '<', '<<')
Map('n', '<', '<<')
Map('n', '$', 'g_')
Map('v', '$', 'g_')
Map('n', 'gl', 'g_')
Map('v', 'gl', 'g_')
Map('n', '<leader>vv', ':e $MYVIMRC<cr>')
Map('n', '<leader>vr', ':luafile %<cr>')
Map('v', '//', 'y/\\V<C-R>=escape(@",\'/\')<CR><CR>')
Map('n', 'gp', 'p`[')
Map('n', '*', '*N')

Map('n', '<C-j>', '<C-d>')
Map('n', '<C-k>', '<C-u>')
Map('v', '<C-j>', '<C-d>')
Map('v', '<C-k>', '<C-u>')

Map('n', '<leader>ps', ':set spell!<cr>')
Map('n', '<leader>pc', '<c-g>u<Esc>[s1z=`]a<c-g>u')
Map('n', '<leader>pa', ':set list!<cr>')
Map('n', '<leader>gp', function() vim.lsp.buf.format() end)

if vim.env.TMUX == nil then Map('n', '<A-a>', ':silent !$TERM & disown<cr>') end

Map('', '<A-w>', '<C-w>')
Map('t', '<A-a>', '<C-\\><C-n>')

-- Map('n', '\\\\', '<Esc>/Enter>"_c4l')

Map('n', 'cd', ':cd ')

-- Cmd "inoremap <expr> <C-j>   pumvisible() ? '\\<C-n>' : '\\<C-j>'"
-- Cmd "inoremap <expr> <-k>   pumvisible() ? '\\<C-p>' : '\\<C-k>'"
-- Cmd "inoremap <expr> <Tab>   pumvisible() ? '\\<C-n>' : '\\<Tab>'"
-- Cmd "inoremap <expr> <S-Tab> pumvisible() ? '\\<C-p>' : '\\<S-Tab>'"
