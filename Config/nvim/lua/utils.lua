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
