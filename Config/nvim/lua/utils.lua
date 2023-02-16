Map = function(mode, key, cmd, opts)
  local options = { noremap = true, silent = true }
  if type(cmd) == "function" then
    options.callback = cmd
    cmd = ""
  end
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, key, cmd, options)
end

BMap = function(mode, key, cmd, opts)
  local options = { noremap = true, silent = true }
  if type(cmd) == "function" then
    options.callback = cmd
    cmd = ""
  end
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_buf_set_keymap(0, mode, key, cmd, options)
end

Cmd = vim.api.nvim_command

Sad = function(line_nr, from, to, fname)
  local template = "silent !sed -i '%s\\!b;s/%s/%s/' %s"
  vim.cmd(string.format(template, line_nr, from, to, fname))
end

IncreasePadding = function()
  -- Sad(6, 3, 4, '~/.config/alacritty/alacritty.yml')
  -- Sad(7, 3, 4, '~/.config/alacritty/alacritty.yml')
end

DecreasePadding = function()
  -- Sad(6, 4, 3, '~/.config/alacritty/alacritty.yml')
  -- Sad(7, 4, 3, '~/.config/alacritty/alacritty.yml')
end

