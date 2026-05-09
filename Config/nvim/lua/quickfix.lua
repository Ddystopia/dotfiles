--[[
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local function jump_and_close(cmd)
      vim.cmd(cmd)      -- jump to item
      vim.cmd("cclose") -- close quickfix
    end

    local function jump_keep(cmd)
      vim.cmd(cmd)      -- jump to item
      vim.cmd("wincmd p") -- go back to quickfix

      -- temporary <C-o> mapping
      vim.keymap.set("n", "<C-o>", function()
        vim.keymap.del("n", "<C-o>", { buffer = 0 })
        vim.cmd("normal! <C-o>")
      end, { buffer = 0, remap = false })
    end

    -- navigation
    -- vim.keymap.set("n", "k", "<Up><CR><C-w>p", { buffer = true, remap = false, desc = "Navigate up quickfix" })
    -- vim.keymap.set("n", "j", "<Down><CR><C-w>p", { buffer = true, remap = false, desc = "Navigate down quickfix" })
    vim.keymap.set("n", "j", "<Cmd>keepjumps normal! j<CR><Cmd>keepjumps .cc<CR><Cmd>wincmd p<CR>", {
        buffer = true,
        remap = false,
        desc = "Navigate down quickfix",
    })

    vim.keymap.set("n", "k", "<Cmd>keepjumps normal! k<CR><Cmd>keepjumps .cc<CR><Cmd>wincmd p<CR>", {
        buffer = true,
        remap = false,
        desc = "Navigate up quickfix",
    })

    -- Enter → open and close quickfix
    vim.keymap.set("n", "<CR>", function()
      jump_and_close("cc")
    end, { buffer = true, desc = "Open quickfix item and close list" })

    -- Note: doesn't work
    -- Shift+Enter → open but keep quickfix (old behavior)
    vim.keymap.set("n", "<S-CR>", function()
      jump_keep("cc")
    end, { buffer = true, desc = "Open quickfix item but keep list" })

    vim.keymap.set("n", "<Esc>", ":cclose<CR>", { buffer = true, desc = "Close quickfix list" })
  end,
})

--]]

-- todo: close the first one

-- quickfix.lua
vim.o.quickfixtextfunc = "v:lua.QfTextFunc"

local EAGER_WIPE = false

local pre_jump_bufs    = {}
local last_preview_buf = nil
local preview_bufs     = {}
local origin_win       = nil
local origin_buf       = nil  -- what origin_win was showing before qf opened
local committed        = false
local initialized      = false
local in_preview       = false
local from_keymap      = false  -- suppresses CursorMoved during j/k/n/N/gg/G
local active_qf_buf    = nil    -- set while a qf window is open; guards against duplicate FileType fires

function SetEagerWipe(enabled)
  EAGER_WIPE = enabled
end

local function snapshot_loaded_bufs()
  local s = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then s[b] = true end
  end
  return s
end

local function buf_in_any_win(buf)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(w) == buf then return true end
  end
  return false
end

local function bdelete_buf(buf)
  if not buf then return end
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if pre_jump_bufs[buf] then return end
  if vim.api.nvim_get_option_value("modified", { buf = buf }) then return end
  if buf_in_any_win(buf) then return end
  pcall(vim.cmd, "bdelete " .. buf)
end

local function release_last_preview()
  local buf = last_preview_buf
  last_preview_buf = nil
  if not buf then return end
  if EAGER_WIPE then bdelete_buf(buf) end
end

local function do_wipe_preview_bufs()
  for buf in pairs(preview_bufs) do
    if vim.api.nvim_buf_is_valid(buf)
      and not pre_jump_bufs[buf]
      and not vim.api.nvim_get_option_value("modified", { buf = buf })
    then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
  preview_bufs     = {}
  last_preview_buf = nil
end

vim.api.nvim_create_augroup("QuickfixSetup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group   = "QuickfixSetup",
  pattern = "qf",
  callback = function()
    local qf_buf = vim.api.nvim_get_current_buf()
    -- FileType can fire multiple times for the same qf window (LSP refreshes the list).
    -- Skip re-initialization when the window is already active.
    if active_qf_buf == qf_buf then return end
    active_qf_buf = qf_buf
    -- Clear per-buffer augroup so re-opening qf doesn't stack BufWinLeave/CursorMoved listeners
    local aug = vim.api.nvim_create_augroup("QuickfixBuf" .. qf_buf, { clear = true })
    committed    = false
    initialized  = false
    in_preview   = false
    from_keymap  = false
    preview_bufs = {}
    origin_win   = vim.fn.win_getid(vim.fn.winnr("#"))
    origin_buf   = origin_win and vim.api.nvim_win_get_buf(origin_win) or nil

    local function get_qf_win()
      for _, w in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(w) == qf_buf then return w end
      end
    end

    local function do_preview(qf_win, idx)
      if in_preview then return end
      in_preview = true
      local ok = pcall(vim.cmd, "keepjumps " .. idx .. "cc")
      if ok then
        local new_buf = vim.api.nvim_get_current_buf()
        if new_buf ~= last_preview_buf then
          release_last_preview()
          if not pre_jump_bufs[new_buf] then
            preview_bufs[new_buf] = true
            last_preview_buf      = new_buf
          else
            last_preview_buf = nil
          end
        end
        vim.api.nvim_set_current_win(qf_win)
      end
      in_preview = false
    end

    vim.schedule(function()
      local qf_win = get_qf_win()
      if not qf_win then return end
      pre_jump_bufs    = snapshot_loaded_bufs()
      last_preview_buf = nil
      preview_bufs     = {}
      vim.api.nvim_set_current_win(qf_win)
      do_preview(qf_win, 1)
      initialized = true
    end)

    local function navigate(motion)
      if not initialized then return end
      local qf_win = vim.api.nvim_get_current_win()
      from_keymap = true
      vim.cmd("keepjumps normal! " .. motion)
      from_keymap = false
      do_preview(qf_win, vim.fn.line("."))
    end

    vim.keymap.set("n", "j",  function() navigate("j")  end, { buffer=true, remap=false, desc="Navigate down" })
    vim.keymap.set("n", "k",  function() navigate("k")  end, { buffer=true, remap=false, desc="Navigate up" })
    vim.keymap.set("n", "gg", function() navigate("gg") end, { buffer=true, remap=false, desc="First entry" })
    vim.keymap.set("n", "G",  function() navigate("G")  end, { buffer=true, remap=false, desc="Last entry" })
    vim.keymap.set("n", "n",  function() navigate("n")  end, { buffer=true, remap=false, desc="Next search match" })
    vim.keymap.set("n", "N",  function() navigate("N")  end, { buffer=true, remap=false, desc="Prev search match" })
    vim.keymap.set("n", "gD", function()
      if not initialized then return end
      do_preview(vim.api.nvim_get_current_win(), vim.fn.line("."))
    end, { buffer=true, remap=false, desc="Preview item" })

    -- Handles `/` search: CursorMoved fires when search moves the cursor,
    -- but is suppressed during our own j/k via from_keymap
    vim.api.nvim_create_autocmd("CursorMoved", {
      group  = aug,
      buffer = qf_buf,
      callback = function()
        if not initialized or in_preview or from_keymap then return end
        local qf_win = get_qf_win()
        if qf_win then do_preview(qf_win, vim.fn.line(".")) end
      end,
    })

    -- <CR>: commit — remove chosen buf from wipe list, close qf
    vim.keymap.set("n", "<CR>", function()
      committed = true
      local idx = vim.fn.line(".")
      local ok = pcall(vim.cmd, "keepjumps " .. idx .. "cc")
      if not ok then
        committed = false
        return
      end
      -- Protect current buf AND origin_win's buf: cc may or may not switch the
      -- active window away from qf_win, so current_buf might still be qf_buf.
      preview_bufs[vim.api.nvim_get_current_buf()] = nil
      if origin_win and vim.api.nvim_win_is_valid(origin_win) then
        preview_bufs[vim.api.nvim_win_get_buf(origin_win)] = nil
      end
      last_preview_buf = nil
      vim.cmd("cclose")
    end, { buffer=true, desc="Open item and close list" })

    -- <S-CR>: commit, keep qf open
    vim.keymap.set("n", "<S-CR>", function()
      committed = true
      local idx = vim.fn.line(".")
      local ok = pcall(vim.cmd, "keepjumps " .. idx .. "cc")
      if not ok then
        committed = false
        return
      end
      preview_bufs[vim.api.nvim_get_current_buf()] = nil
      if origin_win and vim.api.nvim_win_is_valid(origin_win) then
        preview_bufs[vim.api.nvim_win_get_buf(origin_win)] = nil
      end
      last_preview_buf = nil
      local w = get_qf_win()
      if w then vim.api.nvim_set_current_win(w) end
    end, { buffer=true, desc="Open item, keep list" })

    vim.keymap.set("n", "<Esc>", function()
      vim.cmd("cclose")
    end, { buffer=true, desc="Close quickfix list" })

    vim.api.nvim_create_autocmd("BufWinLeave", {
      group  = aug,
      buffer = qf_buf,
      once   = true,
      callback = function()
        if not committed then
          -- Restore origin window's original buffer BEFORE wiping,
          -- so no window is showing a preview buf when we wipe
          vim.schedule(function()
            if origin_win and vim.api.nvim_win_is_valid(origin_win)
              and origin_buf and vim.api.nvim_buf_is_valid(origin_buf)
            then
              vim.api.nvim_win_set_buf(origin_win, origin_buf)
              vim.api.nvim_set_current_win(origin_win)
            end
            do_wipe_preview_bufs()
          end)
        else
          -- Committed: wipe unchosen previews, stay where cc left us
          vim.schedule(do_wipe_preview_bufs)
        end
        committed      = false
        initialized    = false
        active_qf_buf  = nil
      end,
    })
  end,
})

--------------------------------------------------------------------------------

QfTextFunc = function(info)
  local items
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 1 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 1 }).items
  end

  local results = {}

  for i = info.start_idx, info.end_idx do
    local item = items[i]
    local fname = ""

    if item.bufnr and item.bufnr > 0 then
      fname = vim.api.nvim_buf_get_name(item.bufnr)

      -- normalize path
      local rel = vim.fn.fnamemodify(fname, ":~:.")
      if #rel < #fname then fname = rel end

      -- 🔹 Cargo special case
      local cargo = fname:match(".cargo/registry/src/[^/]+/(.+)")
      if cargo then
        -- cargo now starts with "crate-name-version/..."
        fname = cargo
      else
        -- fallback shortening (last 3 components)
        local parts = {}
        for p in fname:gmatch("[^/]+") do parts[#parts+1] = p end
        if #parts > 3 then
          fname = "…/" .. table.concat(parts, "/", #parts - 2)
        end
      end
    end

    local lnum = item.lnum or 0
    local col  = item.col  or 0
    local text = (item.text or ""):match("^%s*(.-)%s*$")

    local entry
    if lnum > 0 and col > 0 then
      entry = ("%s|%d col %d| %s"):format(fname, lnum, col, text)
    elseif lnum > 0 then
      entry = ("%s|%d| %s"):format(fname, lnum, text)
    else
      entry = ("%s| %s"):format(fname, text)
    end

    results[#results+1] = entry
  end

  return results
end

Map('n', '<leader>qc', ':cclose<cr>')

vim.keymap.set('n', '<leader>ce', function()
  -- 1. Get the workspace root using cargo metadata
  local handle = io.popen("cargo metadata --format-version=1 | jq -r '.workspace_root'")
  if not handle then
    print("Failed to run cargo metadata")
    return
  end

  local workspace_root = handle:read("*a"):gsub("\n", "")
  handle:close()

  if workspace_root == "" then
    print("Could not determine Cargo workspace root")
    return
  end

  -- 2. Read and transform the /tmp/e.log file
  local input_file = "/tmp/e.log"
  local output_lines = {}
  for line in io.lines(input_file) do
    local updated = line:gsub("([^%s:]+%.rs)", function(path)
      -- only update if path doesn't start with '/' or contain ':'
      if not path:match("^/") and not path:match("^[a-zA-Z]:") then
        return workspace_root .. "/" .. path
      end
      return path
    end)
    table.insert(output_lines, updated)
  end

  -- 3. Write updated log to a temp file
  local updated_log = "/tmp/e_abs.log"
  local f = io.open(updated_log, "w")
  if not f then
    print("Failed to open output file: " .. updated_log)
    return
  end
  for _, line in ipairs(output_lines) do
    f:write(line .. "\n")
  end
  f:close()

  -- 4. Load into quickfix
  vim.cmd("cfile " .. updated_log)
end, { desc = "Parse and load cargo error log with absolute paths" })

