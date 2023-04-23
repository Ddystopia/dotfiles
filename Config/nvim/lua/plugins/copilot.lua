local COPILOT_CMP = true

local copilot = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  enabled = true,
}

copilot.config = function()
  vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
  require("copilot").setup({
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<C-CR>"
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4
      }
    },
    suggestion = {
      enabled = not COPILOT_CMP,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<C-space>",
        accept_word = false,
        accept_line = false,
        next = "<C-l>",
        prev = "<C-h>",
        dismiss = "<C-l>"
      }
    },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false
    },
    copilot_node_command = 'node', -- Node.js version must be > 16.x
    server_opts_overrides = {}
  })
end

local copilot_cmp = {
  "zbirenbaum/copilot-cmp",
  enabled = COPILOT_CMP,
  config = function() require("copilot_cmp").setup({}) end,
  event = "InsertEnter",
  -- formatters = { insert_text = require('copilot_cmp.format').remove_existing },
  module = 'copilot_cmp',
  dependencies = "zbirenbaum/copilot.lua"
}

return { copilot, copilot_cmp }

