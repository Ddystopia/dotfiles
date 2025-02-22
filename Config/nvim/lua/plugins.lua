local M = {
  {
    "smartpde/debuglog",
    enabled = false,
    lazy = false,
    config = function()
      local debuglog = require("debuglog")
      debuglog.setup()
      debuglog.enable("*")
      -- debuglog.disable()
    end
  },
  {
    'stevearc/profile.nvim',
    lazy = false,
    confit = function()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end

      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format("Wrote %s", filename))
            end
          end)
        else
          prof.start("*")
        end
      end
      vim.keymap.set("", "<f1>", toggle_profile)
    end
  },
  {
    dir = "/home/ddystopia/code/cmps/cmp-cmdline",
    lazy = false,
    enabled = true,
    -- enabled = false,
    dependencies = { 'hrsh7th/nvim-cmp', {
      'tzachar/fuzzy.nvim',
      lazy = false,
      dependencies = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          lazy = false,
        },
      }
    } },
    config = function()
      local cmp = require('cmp')
  
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man' }
            }
          }
        })
      })
    end
  },
  {
    'hrsh7th/cmp-buffer',
    lazy = false,
    config = function()
      require('cmp').setup({
        sources = {
          { name = 'buffer' },
        },
      })
    end

  },
  {
    'whonore/Coqtail',
    ft = { "coq" },
    config = function()
      vim.g.coqtail_nomap = 1
      BMap('n', '<leader>cc', ':CoqStart<CR>')
      BMap('n', '<leader>cq', ':CoqStop<CR>')
      BMap('n', '<C-j>', ':CoqNext<CR>')
      BMap('n', '<C-k>', ':CoqUndo<CR>')
      BMap('n', 'cl', ':CoqToLine<CR>')
      BMap('n', 'fj', ':CoqNext<CR>')
      BMap('n', 'fk', ':CoqUndo<CR>')
      BMap('n', 'fl', ':CoqToLine<CR>')
      BMap('n', '<leader>ct', ':CoqToTop<CR>')
      BMap('n', '<leader>cG', ':CoqJumpToEnd<CR>')
      BMap('n', '<leader>cE', ':CoqJumpToError<CR>')
      BMap('n', 'gd', ':CoqGotoDef<CR>')
    end
  },
  {
    'mbbill/undotree',
    keys = { '<leader>u' },
    config = function()
      Map('n', '<leader>u', ':UndotreeToggle<cr><C-w>h<C-w>k')
    end
  },
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
          always_show_bufferline = true,
          --[[
            my try go filter "inactive-code" diagnostics, but it diagnostics_indicator
            is wrong function

          diagnostics_indicator = function(count, _, _, context)
            local only_inactive_code = count ~= 0

            for _, diag in pairs(vim.diagnostic.get(context.buffer.id)) do
              print(diag.code)
              if diag.code ~= "inactive-code" then
                only_inactive_code = false
                break
              end
            end


            if only_inactive_code then
              print("disabling")
              return ""
            else
              print("enabling")
              return " "
            end
          end
          ]]
        },
        highlights = {
          fill = { bg = '#21222C' },
          buffer_selected = { bold = true, italic = false },
          hint = {
            fg = require("bufferline.colors").get_color({ name = "Comment", attribute = "fg" }),
          },
          hint_selected = {
            fg = require("bufferline.colors").get_color({ name = "Normal", attribute = "fg" }),
            italic = false,
            bold = false,
          },
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
    end
  }, --
  {
    -- highlights yank
    'machakann/vim-highlightedyank',
    lazy = false,
    init = function() vim.g.highlightedyank_highlight_duration = 250 end
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
    -- tool comment code
    'terrortylor/nvim-comment',
    config = function()
      Map("n", "<C-/>", ":CommentToggle<CR>")
      Map("v", "<C-/>", ":CommentToggle<CR>")

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
  }, --
  {
    'windwp/nvim-autopairs',
    lazy = false,
    config = function()
      require('nvim-autopairs').setup({})
      local autopairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      local rules = require('nvim-autopairs').get_rule("'")
      require('nvim-autopairs').remove_rule("'")

      for _, rule in pairs(rules) do
        if rule.filetypes == nil or rule.filetypes[1] ~= "rust" then
          require('nvim-autopairs').add_rule(rule)
        end
      end

      autopairs.add_rules {
        Rule(".", ".", "rust"):with_pair(function() return false end),
        Rule("/", "/", "rust"):with_pair(function() return false end),
        -- Rule("|", "|", "rust")
        --     :with_pair(cond.not_before_regex("~", 1))
        --     :with_pair(cond.not_before_regex("%a%s*$", 5))
        --     :with_pair(ts_cond.is_not_ts_node({ "match_arm" }))
        --     :with_move(function(opts) return opts.char == "|" end),
        Rule("<", ">", { "rust", "typescript" })
            :with_pair(cond.not_before_regex("%d%s*$", 5))
            :with_pair(cond.not_before_regex("%a%s", 2))
            :with_pair(cond.not_before_regex("%)%s", 2))
            :with_pair(cond.not_before_regex(">", 1))
            :with_move(function(opts) return opts.char == ">" end)
      }

      for _, ch in pairs({ 'х', 'ъ', 'э', 'ё', 'ю' }) do
        Map('i', ch, ch)
        Map('i', string.upper(ch), string.upper(ch))
      end
    end
  },
  {
    'lyokha/vim-xkbswitch',
    lazy = false,
    enabled = false,
    init = function()
      vim.g.XkbSwitchEnabled = 1
      -- TODO: Some errors
      -- vim.g.XkbSwitchIMappings = { 'ru', 'sk(qwerty)', 'ua' }
      vim.g.XkbSwitchIMappings = { 'ru' }
    end
  }, --
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
  }, --

  {
    'lervag/vimtex',
    ft = { "tex", "bib" },
    dependencies = { 'KeitaNakamura/tex-conceal.vim', 'godlygeek/tabular' },
    init = function()
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
    end
  }, --
  --[[









============ Disabled ============










  --]]
  {
    'gelguy/wilder.nvim',
    lazy = false,
    enabled = false,
    dependencies = {
      'romgrk/fzy-lua-native', 'kyazdani42/nvim-web-devicons'
      -- 'liuchengxu/vim-clap'
    },
    build = function() vim.cmd [[ UpdateRemotePlugins ]] end,
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':', '/', '?' } })

      wilder.set_option('pipeline', {
        wilder.branch(wilder.python_file_finder_pipeline({
          file_command = function(_, arg)
            if arg ~= nil and arg[0] == '.' then
              return { 'fd', '-tf', '-H' }
            end
            return { 'fd', '-tf' } -- fd -tf -I
          end,
          dir_command = function(_, arg)
            if arg ~= nil and arg[0] == '.' then
              return { 'fd', '-td', '-H' }
            end
            return { 'fd', '-td' }
          end,
          -- filters = { 'fuzzy_filter', 'difflib_sorter' },
          -- filters = { 'clap_filter' },
          path = function()
            local filename = vim.api.nvim_buf_get_name(0)
            return RootPattern(".git", ".project_root", "LICENSE", "Cargo.toml",
                  "package.json", "init.lua", "README.md")(filename) or
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
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = false,
    enabled = false,
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
          WARN = {
            icon = " ",
            color = "warning",
            alt = { "WARNING", "XXX", "IMPORTANT" }
          },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO", "SAFETY" } }
        }
      }
    end
  }, --
  {
    -- indent blankline
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    lazy = false,
    init = function()
      vim.g.indent_blankline_char = '▏'
      vim.g.indent_blankline_char_highlight_list = { "IndentLine" }
      vim.g.indent_blankline_show_first_indent_level = false
      -- vim.g.indent_blankline_show_trailing_blankline_indent = false
      -- vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_filetype_exclude = {
        'markdown', 'mkd', 'tex', 'startify'
      }
    end
  }, --
  {
    -- TODO: Am I using it?
    "ahmedkhalf/project.nvim",
    enabled = false,
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
    -- TODO: look at it later
    'https://github.com/kaarmu/typst.vim',
    lazy = false,
    enabled = false

  }, --
  {
    -- TODO: get used to
    'mfussenegger/nvim-dap',
    enabled = false,
    keys = {
      '<leader>dc', '<leader>dr', '<leader>db', '<leader>dl', '<leader>du',
      '<leader>di', '<leader>ds', '<leader>dt', '<leader>do', '<leader>dn',
      '<leader>dp'
    },
    config = function()
      -- local dap = require('dap')
      -- Toggle breakpoint
      Map('n', '<leader>db', function() require 'dap'.toggle_breakpoint() end)

      -- Continue execution
      Map('n', '<leader>dc', function() require 'dap'.continue() end)

      -- Step over
      Map('n', '<leader>do', function() require 'dap'.step_over() end)

      -- Step into
      Map('n', '<leader>di', function() require 'dap'.step_into() end)

      -- Step out
      Map('n', '<leader>dt', function() require 'dap'.step_out() end)

      -- Open REPL
      Map('n', '<leader>dr', function() require 'dap'.repl.open() end)

      -- Up stack frame
      Map('n', '<leader>du', function() require 'dap'.up() end)

      -- Stop
      Map('n', '<leader>ds', function() require 'dap'.stop() end)

      -- Pause
      Map('n', '<leader>ds', function() require 'dap'.pause() end)

      -- Widget UI (Check dap-widgets documentation for the correct function)
      -- Map('n', '<leader>dw', function() require'dap'.widgets.open() end)
    end

  }, --
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
    'tpope/vim-fugitive',
    enabled = false,
    cmd = { 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete' },
    config = function() end
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
  -- use 'ray-x/lsp_signature.nvim'
}

return M
