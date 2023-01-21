local M = {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost' },
  enabled = true,
  cond = function() return vim.api.nvim_buf_line_count(0) < 20000 end,
  build = function() vim.cmd("TSUpdate") end
}

M.dependencies = {
  'nvim-treesitter/nvim-treesitter-textobjects', --
  'RRethy/nvim-treesitter-textsubjects', --
  'p00f/nvim-ts-rainbow', --
  'romgrk/nvim-treesitter-context', --
  'JoosepAlviste/nvim-ts-context-commentstring'
}

M.config = function()
  -- local enabled = function() return vim.api.nvim_buf_line_count(0) < 50000 end
  local treesitter = require('nvim-treesitter.configs')

  treesitter.setup {
    highlight = { enable = true },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gn',
        node_incremental = 'gn',
        node_decremental = 'gr'
      }
    },

    indent = { enable = true },

    rainbow = {
      enable = false,
      extended_mode = true,
      max_file_lines = nil,
      colors = { "#bf616a", "#ffd700", "#a3de3c", "#ebcb8b", "#88c0d0" },
      termcolors = { "#af5f5f", "#ffd700", "#afff00", "#d7af87", "#afd7ff" }
    },

    context_commentstring = {
      enable = true,
      config = { fish = "# %s", scheme = ";; %s" }
    },

    autotag = { enable = true },

    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["ac"] = "@class.outer",
          ["al"] = "@loop.outer",
          ["ab"] = "@block.outer",
          ["if"] = "@function.inner",
          ["ic"] = "@class.inner",
          ["il"] = "@loop.inner",
          ["ib"] = "@block.inner"
        }
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer"
        },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" }
      }
    },

    textsubjects = {
      enable = true,
      keymaps = { ['.'] = 'textsubjects-smart', [';'] = 'textsubjects-big' }
    }
  }
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
end

return M
