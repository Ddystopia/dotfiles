function Dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
    end
    return s .. '} '
  elseif type(o) == 'function' then
    return 'function () end'
  elseif type(o) == 'string' then
    return '"' .. o .. '"'
  else
    return tostring(o)
  end
end

function DisableSyntaxOnLargeFiles()
  local filename = vim.api.nvim_buf_get_name(0)
  local lines = vim.api.nvim_buf_line_count(0)
  local filesize = vim.fn.getfsize(filename);

  if (filesize > 100 * 1024 or lines > 20000) and lines > 0 then
    vim.cmd('setlocal syntax=off')
  end
end

--- @param buf number
--- @param option string
--- @param value any
function SetLocalOption(buf, option, value)
  vim.api.nvim_buf_set_option(buf, option, value)
end

--- Creates a new auto command.
--- @param event string | table The event(s) that will trigger the handler (callback or command).
--- @param callback fun(args: table):(boolean|nil) Lua function (or Vimscript function name, if string) called when the event(s) is triggered. Lua callback can return true to delete the autocommand. The table argument of the callback function has these keys:
---   id (number): autocommand id
---   event (string): name of the triggered event autocmd-events
---   group (number|nil): autocommand group id, if any
---   match (string): expanded value of <amatch>
---   buf (number): expanded value of <abuf>
---   file (string): expanded value of <afile>
---   data (any): arbitrary data passed from nvim_exec_autocmds()
--- @param opts table | nil Options dictionary:
---   group string|integer, optional: autocommand group name or id to match against.
---   pattern string|table, optional: pattern(s) to match literally autocmd-pattern.
---   buffer integer, optional: buffer number for buffer-local autocommands autocmd-buflocal. Cannot be used with {pattern}.
---   desc string, optional: description (for documentation and troubleshooting).
function AutoCommand(event, callback, opts)
  if opts == nil then
    opts = {}
  end
  opts.callback = callback
  vim.api.nvim_create_autocmd(event, opts)
end

--- @param mode string
--- @param key string
--- @param cmd string | function
--- @param opts table | nil
function Map(mode, key, cmd, opts)
  local options = { noremap = true, silent = true }
  if type(cmd) == "function" then
    options.callback = cmd
    cmd = ""
  end
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, key, cmd, options)
end

--- @param mode string
--- @param key string
--- @param cmd string | function
--- @param opts table | nil
function BMap(mode, key, cmd, opts)
  local options = { noremap = true, silent = true }
  if type(cmd) == "function" then
    options.callback = cmd
    cmd = ""
  end
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_buf_set_keymap(0, mode, key, cmd, options)
end

function OnAttach(client, bufnr)
  -- client.server_capabilities.semanticTokensProvider = nil
  local lspkind = require('lspkind')
  local luasnip = require('luasnip')
  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menu,menuone,noinsert,noselect'

  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end

    local line = vim.api.nvim_win_get_cursor(0)[1]
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local lines = vim.api.nvim_buf_get_lines(0, line - 1, line, true);
    return col > 0 and lines[1]:sub(1, col):match("^%s*$") == nil
  end

  local cmp = require 'cmp'
  local cmp_state = false

  cmp.event:on('menu_closed', function() cmp_state = false end)

  cmp.setup {
    experimental = { ghost_text = true },
    snippet = {
      expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    sources = {
      { name = 'copilot' }, { name = 'path' }, { name = 'nvim_lsp' },
      { name = 'luasnip' }
    },
    mapping = {
      ['<C-p>'] = function()
        cmp.select_prev_item()
        cmp_state = true
      end,
      ['<C-n>'] = function()
        cmp.select_next_item()
        cmp_state = true
      end,
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = function(fallback)
        if cmp.visible() and cmp.get_selected_entry() ~= nil then
          cmp.confirm()
        else
          fallback()
        end
      end,
      ['<C-space>'] = function()
        if cmp.visible() then
          cmp.confirm()
        else
          cmp.complete()
        end
      end,
      ['<Tab>'] = function(fallback)
        if cmp.visible() and not luasnip.in_snippet() then
          if cmp_state or cmp.get_selected_entry() == nil then
            cmp.select_next_item()
          else
            cmp.complete_common_string()
          end

          cmp_state = true
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() and not luasnip.in_snippet() then
          cmp_state = true
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    },
    -- completion = { autocomplete = false },
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol',       -- show only symbol annotations
        maxwidth = 30,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        before = function(_, vim_item) return vim_item end,
        symbol_map = { Copilot = "" }
      })
    }
  }

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    Map("n", "<leader>hf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
  end
end

-- from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/util.lua
local _path = (function()
  local uv = vim.loop

  local is_windows = uv.os_uname().version:match 'Windows'
  local function escape_wildcards(path)
    return path:gsub('([%[%]%?%*])', '\\%1')
  end

  local function sanitize(path)
    if is_windows then
      path = path:sub(1, 1):upper() .. path:sub(2)
      path = path:gsub('\\', '/')
    end
    return path
  end

  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function is_dir(filename) return exists(filename) == 'directory' end

  local function is_file(filename) return exists(filename) == 'file' end

  local function is_fs_root(path)
    if is_windows then
      return path:match '^%a:$'
    else
      return path == '/'
    end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match '^%a:' or filename:match '^\\\\'
    else
      return filename:match '^/'
    end
  end

  local function dirname(path)
    local strip_dir_pat = '/([^/]+)$'
    local strip_sep_pat = '/$'
    if not path or #path == 0 then return end
    local result = path:gsub(strip_sep_pat, ''):gsub(strip_dir_pat, '')
    if #result == 0 then
      if is_windows then
        return path:sub(1, 2):upper()
      else
        return '/'
      end
    end
    return result
  end

  local function path_join(...)
    return table.concat(vim.tbl_flatten { ... }, '/')
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
      if not dir then return end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then return dir, path end
      if is_fs_root(dir) then break end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    local function it(_, v)
      if v and not is_fs_root(v) then
        v = dirname(v)
      else
        return
      end
      if v and uv.fs_realpath(v) then
        return v, path
      else
        return
      end
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if not path then return false end

    local function cb(dir, _) return dir == root end

    local dir, _ = traverse_parents(path, cb)

    return dir == root
  end

  local path_separator = is_windows and ';' or ':'

  return {
    escape_wildcards = escape_wildcards,
    is_dir = is_dir,
    is_file = is_file,
    is_absolute = is_absolute,
    exists = exists,
    dirname = dirname,
    join = path_join,
    sanitize = sanitize,
    traverse_parents = traverse_parents,
    iterate_parents = iterate_parents,
    is_descendant = is_descendant,
    path_separator = path_separator
  }
end)()

-- from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/util.lua
function RootPattern(...)
  local function search_ancestors(startpath, func)
    vim.validate { func = { func, 'f' } }
    if func(startpath) then return startpath end
    local guard = 100
    for path in _path.iterate_parents(startpath) do
      -- Prevent infinite recursion if our algorithm breaks
      guard = guard - 1
      if guard == 0 then return end

      if func(path) then return path end
    end
  end
  local function strip_archive_subpath(path)
    -- Matches regex from zip.vim / tar.vim
    path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1',
      '')
    path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
    return path
  end
  local patterns = vim.tbl_flatten { ... }
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      for _, p in ipairs(vim.fn.glob(_path.join(_path.escape_wildcards(path),
        pattern), true, true)) do
        if _path.exists(p) then return path end
      end
    end
  end
  return function(startpath)
    startpath = strip_archive_subpath(startpath)
    return search_ancestors(startpath, matcher)
  end
end
