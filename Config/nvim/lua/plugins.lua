local M = {
  {
    'gelguy/wilder.nvim',
    lazy = false,
    dependencies = {
      'romgrk/fzy-lua-native', 'kyazdani42/nvim-web-devicons',
      -- 'liuchengxu/vim-clap'
    },
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':', '/', '?' } })

      wilder.set_option('pipeline', {
        wilder.branch(wilder.python_file_finder_pipeline({
          file_command = function (arg)
            if arg.len() > 0 and arg[0] == '.' then
              return { 'fd', '-tf', '-IH' }
            end
            return { 'fd', '-tf' }
          end,
          dir_command = function (arg)
            if arg.len() > 0 and arg[0] == '.' then
              return { 'fd', '-td', '-IH' }
            end
            return { 'fd', '-td' }
          end,
          -- filters = { 'fuzzy_filter', 'difflib_sorter' },
          -- filters = { 'clap_filter' },
          path = function()
            local filename = vim.api.nvim_buf_get_name(0)
            return RootPattern(".git", ".project_root", "LICENSE", "Cargo.toml",
                  "package.json", "init.lua")(filename) or
                vim.loop.os_homedir()
          end
        }), wilder.cmdline_pipeline(), wilder.python_search_pipeline())
      })

      wilder.set_option('renderer', wilder.renderer_mux({
        [':'] = wilder.popupmenu_renderer({
          highlighter = wilder.lua_fzy_highlighter(),
          left = { ' ', wilder.popupmenu_devicons() },
          right = { ' ', wilder.popupmenu_scrollbar() }
        }),
        ['/'] = wilder.wildmenu_renderer({
          highlighter = wilder.lua_fzy_highlighter()
        })
      }))
    end
  }, --
  {
    'sbdchd/neoformat',
    keys = { '<leader>F' },
    config = function()
      Map('n', '<leader>F', function()
        if not pcall(function() vim.lsp.buf.format() end) then
          vim.cmd [[
            silent Neoformat
            write
          ]];
        end
      end)

      Map('v', '<leader>F', function()
        local function feedkeys(keys, mode)
          local cmd = vim.api.nvim_replace_termcodes(
            keys, true, false, true);
          vim.api.nvim_feedkeys(cmd, mode, true)
        end
        local function lsp_format()
          feedkeys(':<C-U>silent \'<,\'>lua vim.lsp.format()<CR>', 'n')
        end

        if not pcall(lsp_format) then
          feedkeys(':<C-U>silent \'<,\'>Neoformat<CR>', 'v')
        end
      end)
      vim.g.latexindent_opt = "-m"
      vim.g.neoformat_markdown_remark = {
        exe = 'prettier',
        args = { '--prose-wrap=always', '--stdin-filepath', '"%:p"' },
        stdin = 1,
        try_node_exe = 1
      }
      vim.g.neoformat_java_astyle = {
        exe = 'astyle',
        args = { '--indent=spaces=2' },
        replace = 1
      }
      vim.g.neoformat_html_htmlbeautify = {
        exe = 'html-beautify',
        args = { '--indent-size', '2' }
      }
      vim.g.neoformat_rust_rustfmt = {
        exe = 'rustfmt',
        -- args = { '--config', 'tab_spaces=2' },
        replace = 0,
        stdin = 1
      }
      vim.g.neoformat_lua_luaformatter = {
        exe = 'lua-format',
        args = {
          '--indent-width=2', '--spaces-inside-table-braces',
          '--column-limit=80'
        }
      }
      vim.g.neoformat_tex_latexindent = {
        exe = 'latexindent' --
        --
      }
    end
  }, --
  {
     -- bar at the top
    'akinsho/nvim-bufferline.lua',
    lazy = false,
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      local b = require("bufferline")
      b.setup {
        options = {
          --      mappings = false,
          diagnostics = "nvim_lsp",
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true
        },
        highlights = {
          fill = { bg = '#21222C' },
          buffer_selected = { bold = true, italic = false }
        }
      }
    end,
    init = function()
      Map('n', 'gb', function() require("bufferline").pick_buffer() end)

      Map('n', '<C-l>', function() require("bufferline").cycle(1) end)
      Map('n', '<C-h>', function() require("bufferline").cycle(-1) end)
      Map('n', '<Tab>', function() require("bufferline").cycle(1) end)
      Map('n', '<S-Tab>', function() require("bufferline").cycle(-1) end)
      Map('i', '<C-l>', function()
        vim.cmd "stopinsert";
        require("bufferline").cycle(1)
      end)
      Map('i', '<C-h>', function()
        vim.cmd "stopinsert";
        require("bufferline").cycle(-1)
      end)
      Map('n', '<S-h>', function() require("bufferline").move(-1) end)
      Map('n', '<S-l>', function() require("bufferline").move(1) end)
      Map('n', '<C-j>', '<cmd>tabn<cr>')
      Map('n', '<C-k>', '<cmd>tabp<cr>')
    end
  }, --
  {
     -- indent blankline
    'lukas-reineke/indent-blankline.nvim',
    lazy = false,
    config = function()
      vim.g.indent_blankline_char = '▏'
      vim.g.indent_blankline_char_highlight_list = { "IndentLine" }
      vim.g.indent_blankline_show_first_indent_level = false
      -- vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_filetype_exclude = {
        'markdown', 'mkd', 'tex', 'startify'
      }
    end
  }, --
  {
     -- highlights yank
    'machakann/vim-highlightedyank',
    lazy = false,
    config = function() vim.g.highlightedyank_highlight_duration = 250 end
  }, --
  {
     -- colorize colors like this #01dd99
    'norcalli/nvim-colorizer.lua',
    lazy = false,
    config = function()
      require('colorizer').setup({
        '*',
        css = { css = true },
        scss = { scc = true }
      }, { names = false })
    end
  }, --
  {
    'lervag/vimtex',
    ft = { "tex", "bib" },
    dependencies = { 'KeitaNakamura/tex-conceal.vim', 'godlygeek/tabular' },
    config = function()
      vim.cmd "filetype plugin indent on"
      vim.cmd "syntax enable"
      Map('n', '<leader>vp', ':w<cr> :VimtexCompile<cr>')

      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_format_enabled = true
      -- vim.opt.conceallevel=1
      vim.g.tex_conceal = 'abdmg'
      vim.g.vimtex_view_method = 'zathura'

      vim.g.vimtex_view_general_viewer = 'okular'
      vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

      vim.g.vimtex_compiler_method = 'latexrun'
      vim.g.vimtex_syntax_enabled = 0

      vim.g.maplocalleader = ","
    end
  }, --
  {
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup({
        -- Linters prefer comment and line to have a space in between markers
        marker_padding = true,
        -- should comment out empty or whitespace only lines
        comment_empty = true,
        -- trim empty comment whitespace
        comment_empty_trim_whitespace = true,
        -- Should key mappings be created
        create_mappings = true,
        -- Normal mode mapping left hand side
        line_mapping = "gcc",
        -- Visual/Operator mapping left hand side
        operator_mapping = "gc",
        -- text object mapping, comment chunk,,
        comment_chunk_text_object = "ic",
        -- Hook function to call before commenting takes place
        hook = nil
      })
      Map('n', "<C-_>", ":CommentToggle<CR>")
      Map('v', "<C-_>", ":CommentToggle<CR>")
    end,
    lazy = false
  }, --
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- { 'jiangmiao/auto-pairs', config = function() vim.g.AutoPairsMapCh = false end }
  {
    'windwp/nvim-autopairs',
    lazy = false,
    config = function()
      require('nvim-autopairs').setup({})
      -- local Rule = require('nvim-autopairs.rule')
      -- local npairs = require('nvim-autopairs')

      -- npairs.add_rule(Rule("<", ">", "typescript"))
      -- npairs.add_rule(Rule("<", ">", "typescriptreact"))
      -- npairs.add_rule(Rule("<", ">", "rust"))
      Map('i', 'х', 'х')
      Map('i', 'ъ', 'ъ')
      Map('i', 'э', 'э')
      Map('i', 'ё', 'ё')
      Map('i', 'Х', 'Х')
      Map('i', 'Ъ', 'Ъ')
      Map('i', 'Э', 'Э')
      Map('i', 'Ё', 'Ё')
    end
  },                                            --
  { 'tversteeg/registers.nvim', lazy = false }, --
  {
    'phaazon/hop.nvim',
    name = 'hop',
    config = true,
    init = function()
      -- Map("n", "<leader>h", function() require'hop'.hint_words() end)
      -- Map("n", "<leader>k", function() require'hop'.hint_lines() end)
      Map("n", "<leader>l", function() require 'hop'.hint_words() end)
      Map("n", "<leader>j", function() require 'hop'.hint_lines() end)
      Map("n", "<leader>f", function() require 'hop'.hint_char1() end)
      Map("n", "<leader>s", function() require 'hop'.hint_char2() end)
    end
  }, -- use 'ray-x/lsp_signature.nvim'
  {
     -- TODO: Am I using it?
    "ahmedkhalf/project.nvim",
    lazy = false,
    config = function()
      require("project_nvim").setup {
        patterns = { ".git", "Makefile", "package.json", "init.lua" },
        detection_methods = { ".git", "Makefile", "package.json", "init.lua" },
        exclude_dirs = { "client" }
      }
    end
  }, -- use 'jackguo380/vim-lsp-cxx-highlight'
  {
     -- TODO: Doesn't work
    'simrat39/symbols-outline.nvim',
    keys = { '<leader>;' },
    cmd = { "SymbolsOutline" },
    config = function()
      require("symbols-outline").setup()
      Map('n', '<leader>;', ':SymbolsOutline<CR>')
    end
  }, --
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      vim.cmd "au BufReadPost,BufNewFile,BufRead * hi clear TODO"
      require("todo-comments").setup {
        signs = false,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }
          },
          TODO = { icon = " ", color = "info" },
          HACK = {
            icon = " ",
            color = "warning",
            alt = { "FUCK", "SHIT", "BAD" }
          },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO", "SAFETY" } }
        }
      }
    end
  }, --
  {
     -- xkbswitch TODO: doesn't work
    'lyokha/vim-xkbswitch',
    lazy = true,
    enabled = false,
    config = function()
      vim.g.XkbSwitchEnabled = 1
      vim.g.XkbSwitchIMappings = { 'ru', 'sk(qwerty)', 'ua' }
    end
  }, --
  { 'folke/neodev.nvim',        ft = { 'lua' }, config = true }, {
  'luochen1990/rainbow',
  lazy = false,
  enabled = false,
  config = function()
    vim.g.rainbow_active = 1;
    vim.g.grainbow_conf = {
      -- guifgs = { 'royalblue3', 'darkorange3', 'seagreen3', 'firebrick' },
      -- ctermfgs = { 'lightblue', 'lightyellow', 'lightcyan', 'lightmagenta' },
      guifgs = { "#bf616a", "#ffd700", "#a3de3c", "#ebcb8b", "#88c0d0" },
      ctermfgs = { "#af5f5f", "#ffd700", "#afff00", "#d7af87", "#afd7ff" },
      guis = { '' },
      cterms = { '' },
      operators = '_,_',
      parentheses = {
        'start=/(/ end=/)/ fold', 'start=/[/ end=/]/ fold',
        'start=/{/ end=/}/ fold', 'start=/</ end=/>/ fold'
      },
      separately = {
        markdown = {
          parentheses_options = 'containedin=markdownCode contained'   -- "enable rainbow for code blocks only
        },
        css = 0,                                                       -- disable this plugin for css files
        nerdtree = 0                                                   -- rainbow is conflicting with NERDTree, creating extra parentheses
      }
    }
  end

},   --
  {
     -- bar at the bottom
    "hoob3rt/lualine.nvim",
    enabled = false,
    lazy = false,
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      local function keymap()
        local handle = io.popen('xkb-switch -p 2> /dev/null')
        if (handle == nil) then return '[[xx]]' end
        local result = handle:read('*l')
        handle:close()
        return '[[' .. result .. ']]'
      end

      require('lualine').setup {
        options = {
          theme = 'ayu_mirage',
          section_separators = { '', '' },
          component_separators = { '|', '|' },
          icons_enabled = true
        },
        sections = {
          lualine_a = { 'mode', keymap },
          lualine_b = { 'branch', 'diff' },
          lualine_c = {
            'buffers', {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' '
            }
          }
          },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        }
      }
    end
  }, --
  {
    'plasticboy/vim-markdown',
    dependencies = { 'godlygeek/tabular' },
    ft = { "markdown" },
    enabled = false
  }, --
  {
    'mhinz/vim-startify',
    lazy = false,
    enabled = false,
    config = function()
      vim.g.startify_lists = {
        { type = 'dir',   header = { "MRU [" .. vim.fn.getcwd() .. "]" } },
        { type = 'files', header = { "MRU [global]" } }
      }
      vim.g.startify_fortune_use_unicode = 1
      -- vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
    end
  } --
  --
  --[[ use {
    'andweeb/presence.nvim',
    config = function() require("presence"):setup({}) end
  } ]]
}

return M
