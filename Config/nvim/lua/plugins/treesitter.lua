local M = {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  cond = function()
    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
      local filename = vim.api.nvim_buf_get_name(buf_id)
      local lines = vim.api.nvim_buf_line_count(buf_id)
      if vim.fn.getfsize(filename) > 100 * 1024 and lines > 0 then
        return false
      end
    end
    return true
  end,
  build = function() require("nvim-treesitter.install").update({ with_sync = true })() end
}

M.dependencies = {
  { 'nvim-treesitter/playground' },
  { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = false }, --
  { 'RRethy/nvim-treesitter-textsubjects',         lazy = false }, --
  { 'HiPhish/nvim-ts-rainbow2',                    lazy = false, },
  -- 'romgrk/nvim-treesitter-context',                             -- Shit
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = false }
}

M.init = function()
  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.typst = {
    -- install_info = {
    --   url = "https://github.com/TheOnlyMrCat/tree-sitter-typst",
    --   files = { "src/parser.c", "src/scanner.c" },
    --   generate_requires_npm = false,
    --   requires_generate_from_grammar = false
    -- },
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

  local rainbow = require('ts-rainbow')

  treesitter.setup {
    ensure_installed = {
      'rust', 'c', 'cpp', 'javascript', 'lua', 'python', 'bash',
      'fish', 'html', 'css', 'dockerfile', 'diff', 'fish', 'go',
      'json', 'make', 'markdown', 'python', 'regex', 'scheme',
      'sxhkdrc', 'typescript', 'yaml', 'zig', 'tsx'
    },

    highlight = { enable = true, additional_vim_regex_highlighting = false },

    rainbow = {
      -- enable = false,
      -- extended_mode = true,
      -- max_file_lines = nil,
      -- colors = rainbow_colors,
      disable = { 'cpp' },
      query = {
        global = 'rainbow-parens',
        html = 'rainbow-tags',
        tsx = 'rainbow-parens',
      },
      strategy = rainbow.strategy.global,
      hlgroups = {
        'TSRainbowRed',
        'TSRainbowYellow',
        'TSRainbowBlue',
        'TSRainbowOrange',
        'TSRainbowGreen',
        'TSRainbowViolet',
        'TSRainbowCyan'
      },
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gn',
        node_incremental = 'gn',
        node_decremental = 'gr'
      }
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
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
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
