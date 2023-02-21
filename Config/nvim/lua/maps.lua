CloseBuffer = function()
  if vim.fn.expand("%") == "" or #vim.fn.getbufinfo { buflisted = 1 } < 2 then
    vim.cmd "q"
  end

  if not vim.bo.readonly then Cmd "w" end

  vim.cmd "bdelete"
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

vim.cmd 'command! -nargs=* -complete=file E :silent !$TERM -e sh -c "cd `pwd`; nvim <args>"'

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
Map('n', '$', 'g_')
Map('v', '$', 'g_')
Map('n', '<leader>vv', ':e $MYVIMRC<cr>')
Map('n', '<leader>vr', ':luafile %')
Map('n', 'gp', 'p`[')

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

--[[
-- TODO:
function! QuitNetrw()
  for i in range(1, bufnr($))
    if buflisted(i)
      if getbufvar(i, '&filetype') == "netrw"
        silent exe 'bwipeout ' . i
      endif
    endif
  endfor
endfunction

autocmd MyAutoCmd VimLeavePre *  call QuitNetrw()
--]]
