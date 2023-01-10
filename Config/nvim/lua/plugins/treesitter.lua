local M = {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost' },
  build = function() vim.cmd("TSUpdate") end
}

M.dependencies = {
  'nvim-treesitter/nvim-treesitter-textobjects', --
  'RRethy/nvim-treesitter-textsubjects', 'p00f/nvim-ts-rainbow'
  -- 'romgrk/nvim-treesitter-context'
}

M.config = function()
  local treesitter = require('nvim-treesitter.configs')

  treesitter.setup {
    highlight = {
      enable = true,
      disable = function(_, bufnr) -- lang: str, bufnr: buf    Disable in large buffers
        return vim.api.nvim_buf_line_count(bufnr) > 50000
      end

    },

    incremental_selection = {
      enable = true,
      keymaps = { init_selection = 'gn', node_incremental = 'gn', node_decremental = 'gr' }
    },

    indent = { enable = true },

    rainbow = {
      enable = true,
      disable = { "html" },
      extended_mode = true,
      colors = { "#bf616a", "#ffd700", "#a3de3c", "#ebcb8b", "#88c0d0" }
      -- colors = { "#d900ff", "#00ffd9", "#ffd700" }
    },

    context_commentstring = { enable = true, config = { fish = "# %s", scheme = ";; %s" } },

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
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
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
