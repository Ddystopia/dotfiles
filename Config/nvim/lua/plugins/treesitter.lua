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
  {
    'p00f/nvim-ts-rainbow',
    config = function()
      vim.cmd [[
    hi rainbowcol1 guifg=#bf616a
    hi rainbowcol2 guifg=#ffd700
    hi rainbowcol3 guifg=#a3de3c
    hi rainbowcol4 guifg=#ebcb8b
    hi rainbowcol5 guifg=#88c0d0
  ]]
    end
  }, --
  'romgrk/nvim-treesitter-context', --
  'JoosepAlviste/nvim-ts-context-commentstring'
}

M.init = function()
  local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
  parser_config.typst = {
    install_info = {
      url = "https://github.com/TheOnlyMrCat/tree-sitter-typst",
      files = { "src/parser.c", "src/scanner.c" },
      generate_requires_npm = false,
      requires_generate_from_grammar = false
    },
    -- install_info = {
    --   url = "https://github.com/SeniorMars/tree-sitter-typst",
    --   branch = "main",
    --   files = { "src/parser.c", "src/scanner.c" },
    --   generate_requires_npm = true,
    --   requires_generate_from_grammar = false
    -- },
    filetype = "typst"
  }
end

M.config = function()
  -- local enabled = function() return vim.api.nvim_buf_line_count(0) < 50000 end
  local treesitter = require('nvim-treesitter.configs')

  treesitter.setup {
    highlight = { enable = true, additional_vim_regex_highlighting = false },

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
      enable = true,
      -- disable = { "html" },
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
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer"
        }
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
