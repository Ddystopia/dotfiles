vim.cmd('packadd packer.nvim')

Map('n', '<leader>PP', ':PackerCompile<CR>')
Map('n', '<leader>PS', ':PackerSync<CR>')

local packer = require('packer')
return packer.startup(function()
  local use = packer.use

  use 'dstein64/vim-startuptime'

  use { 'wbthomason/packer.nvim', opt = true }

  -- theme
  use {
    'dracula/vim',
    config = function()
      Cmd('colorscheme dracula')
      Cmd('hi CursorLine guibg=#21222C')
      Cmd('hi CursorLineNr guifg=#F1FA8C guibg=#21222C gui=none')
      Cmd('hi IndentLine guifg=#44475a')
    end
  }

  use {
    'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
    config = function()
      local nvim_lsp = require('lspconfig')
      local luasnip = require('luasnip')
      -- local root_pattern = require('util.root_pattern')

      local on_attach = function(client, bufnr)
        -- require('lsp_signature').on_attach({
        --   bind = true,
        --   hint_enable = false,
        --   hi_parameter = "Todo",
        --   handler_opts = { border = "none" }
        -- })
        -- -- -- luasnip setup
        -- local luasnip = require 'luasnip'
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

        -- Set completeopt to have a better completion experience
        vim.o.completeopt = 'menu,menuone,noinsert,noselect'
        -- nvim-cmp setup
        local cmp = require 'cmp'
        cmp.setup {
          snippet = { expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end },
          mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true
            },
            ['<Tab>'] = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end,
            ['<S-Tab>'] = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end
          },
          -- completion = { autocomplete = false },
          sources = { { name = 'nvim_lsp' }, { name = 'luasnip' } }
        }

        --         vim.opt.completeopt = "menuone,noinsert,noselect"
        --         vim.g.completion_enable_auto_signature = 0
        --         vim.g.completion_enable_auto_popup = 0
        -- Cmd('imap <s-tab> <Plug>(completion_smart_s_tab)')
        -- Map('i', '<tab>', 'cmp.mapping.complete')
        -- Cmd('imap <c-space> <Plug>(completion_trigger)')
        --         vim.g.completion_matching_smart_case = 1
        --         vim.g.completion_matching_strategy_list = {
        --           'exact', 'substring', 'fuzzy', 'all'
        --         }

        --         vim.g.completion_confirm_key = ''

        --         require('completion').on_attach()

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        -- buf_map('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>')
        Map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
        Map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
        Map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
        Map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        Map('n', '<A-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

        Map('n', '<leader>la', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        Map('n', '<leader>lr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        Map('n', '<leader>ll',
            '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

        -- buf_map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        Map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
        Map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        Map('n', '<leader>a', '<Cmd>lua vim.lsp.buf.code_action()<CR>')

        Map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
        Map('n', '[d', '<cmd>lua vim.diagnostic.get_prev()<CR>')
        Map('n', ']d', '<cmd>lua vim.diagnostic.get_next()<CR>')
        Map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
          Map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
        elseif client.resolved_capabilities.document_range_formatting then
          Map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
        end
      end
      local servers = {
        "bashls", "vimls", "vuels", "tsserver", "yamlls", "jsonls", "cmake", "gopls",
        "cssls", "rust_analyzer", "pyright"
      }
      for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup { on_attach = on_attach } end

      nvim_lsp.emmet_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "css", "typescriptreact", "javascriptreact" }
      })

      nvim_lsp.ccls.setup {
        cmd = { "ccls" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        single_file_support = false,
        init_options = {
          compilationDatabaseDirectory = "build",
          index = { threads = 0 },
          clang = { excludeArgs = { "-frounding-math" } }
        }
      }

      nvim_lsp.texlab.setup {
        settings = {
          latex = {
            build = {
              args = {
                "-pdf", "-interaction=nonstopmode", "-synctex=1", "-outdir=./build", "%f"
              },
              outputDirectory = "./build",
              onSave = true
            },
            lint = { onChange = true }
          }
        },
        on_attach = on_attach
      }

      local luadev = require("lua-dev").setup({
        library = { vimruntime = false },
        lspconfig = {
          cmd = { "lua-language-server" },
          on_attach = on_attach
          -- nma
        }
      })
      nvim_lsp.sumneko_lua.setup(luadev)

      -- nvim_lsp.sumneko_lua.setup {
      --   cmd = { "/usr/bin/lua-language-server" },
      --   settings = {
      --     Lua = {
      --       runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
      --       diagnostics = { globals = { 'vim' } },
      --       workspace = {
      --         library = {
      --           [vim.fn.expand('$VIMRUNTIME/lua')] = true,
      --           [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
      --         }
      --       }
      --     }
      --   },
      --   on_attach = on_attach
      -- }
      -- local eslint = {
      --   lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
      --   lintStdin = true,
      --   lintFormats = { "%f:%l:%c: %m" },
      --   lintIgnoreExitCode = true,
      --   formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
      --   formatStdin = true
      -- }
      -- local function eslint_config_exists()
      --   local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)
      --   if not vim.tbl_isempty(eslintrc) then
      --     return true
      --   end
      --   if vim.fn.filereadable("package.json") then
      --     if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      --       return true
      --     end
      --   end
      --   return false
      -- end
      -- nvim_lsp.clangd.setup {
      --   cmd = {
      --     'clangd', '--header-insertion=never', '--suggest-missing-includes',
      --     '--background-index', '-j=8', '--cross-file-rename',
      --     '--pch-storage=memory', '--clang-tidy', -- '-std=c++17',
      --     '--clang-tidy-checks=-clang-analyzer-*,bugprone-*,misc-*,-misc-non-private-member-variables-in-classes,performance-*,-performance-no-automatic-move,modernize-use-*,-modernize-use-nodiscard,-modernize-use-trailing-return-type'
      --   },
      --   -- on_init = require'clangd_nvim'.on_init,
      --   -- callbacks = lsp_status.extensions.clangd.setup(),
      --   capabilities = {
      --     capabilities = { window = { workDoneProgress = true } },
      --     textDocument = {
      --       completion = { completionItem = { snippetSupport = true } },
      --       semanticHighlightingCapabilities = { semanticHighlighting = true }
      --     }
      --   },
      --   init_options = {
      --     clangdFileStatus = true,
      --     usePlaceholders = true,
      --     completeUnimported = true
      --   },
      --   on_attach = function() end
      -- }

    end
  }

  -- bar at the bottom
  use {
    "hoob3rt/lualine.nvim",
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local function keymap()
        local handle = io.popen('xkb-switch -p')
        local result = handle:read('*l')
        handle:close()
        return '[[' .. result .. ']]'
      end

      require('lualine').setup {
        options = {
          theme = 'dracula',
          section_separators = { '', '' },
          component_separators = { '|', '|' },
          icons_enabled = true
        },
        sections = {
          lualine_a = { 'mode', keymap },
          lualine_b = { 'branch', 'diff' },
          lualine_c = {
            'filename', {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
            }
          },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        }
      }
    end
  }
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      local b = require("bufferline")
      b.setup {
        options = {
          --      mappings = false,
          diagnostics = "nvim_diagnostic",
          show_buffer_close_icons = false,
          always_show_bufferline = false
        },
        highlights = { fill = { guibg = '#21222C' }, buffer_selected = { gui = 'bold' } }
      }
      Map('n', '<C-h>', ':lua require("bufferline").cycle(-1)<CR>')
      Map('n', '<C-l>', ':lua require("bufferline").cycle(1)<CR>')
      Map('n', 'H', ':lua require("bufferline").move(-1)<CR>')
      Map('n', 'L', ':lua require("bufferline").move(1)<CR>')
      Map('n', 'gb', ':lua require("bufferline").pick_buffer()<CR>')
    end
  }
  use {
    'lyokha/vim-xkbswitch',
    config = function()
      vim.g.XkbSwitchEnabled = 1
      vim.g.XkbSwitchIMappings = { 'ru' }
    end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.g.indent_blankline_char = '▏'
      vim.g.indent_blankline_char_highlight_list = { "IndentLine" }
      vim.g.indent_blankline_show_first_indent_level = false
      -- vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_filetype_exclude = { 'markdown', 'tex', 'startify' }
    end
  }
  use {
    'machakann/vim-highlightedyank',
    config = function() vim.g.highlightedyank_highlight_duration = 250 end
  }

  -- colorize colors like this #01dd99
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({ '*', css = { css = true }, scss = { scc = true } },
                                 { names = false })
    end
  }

  -- use { 'NFrid/due.nvim', config = function() require('due_nvim').setup {} end }

  use {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_lists = {
        { type = 'dir', header = { "MRU [" .. vim.fn.getcwd() .. "]" } },
        { type = 'files', header = { "MRU [global]" } }
      }
      vim.g.startify_fortune_use_unicode = 1
      -- vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
    end
  }

  use {
    'plasticboy/vim-markdown',
    config = function()
      vim.g.vim_markdown_toc_autofit = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_new_list_item_indent = 2
    end
  }
  -- use 'lervag/vimtex'

  -- use {
  --   'nvim-telescope/telescope.nvim',
  --   requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
  --   config = function()
  --     require('telescope').setup {
  --       defaults = { file_ignore_patterns = { "node_modules" } }
  --     }

  --     Map('n', '<leader>t', '<cmd>Telescope<CR>')
  --     Map('n', '<leader>o', '<cmd>lua require("telescope.builtin").fd()<CR>')
  --     -- Map('n', '<leader>f', '<cmd>lua require("telescope.builtin").fd()<CR>')
  --     -- Map('n', '<leader>o', '<cmd>lua require("telescope.builtin").buffers()<CR>')
  --     Map('n', '<leader>m', '<cmd>lua require("telescope.builtin").marks()<CR>')
  --     Map('n', '<leader>r',
  --         '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>')
  --     Map('n', '<leader>R',
  --         '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>')
  --     Map('n', '<C-f>',
  --         '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>')
  --     Map('n', '<F1>', '<cmd>lua require("telescope.builtin").commands()<CR>')
  --     Map('n', '<leader>d',
  --         '<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<CR>')
  --     Map('n', '<leader>u', ':TodoTelescope<CR>')
  --   end
  -- }

  use {
    'tpope/vim-commentary',
    config = function() 
      Cmd "au FileType apache setlocal commentstring=#%s"
      Cmd "au FileType scheme setlocal commentstring=;;%s"
    end
  }
  use 'tpope/vim-surround'
  use 'kana/vim-repeat'
  -- use { 'jiangmiao/auto-pairs', config = function() vim.g.AutoPairsMapCh = false end }
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')

      npairs.add_rule(Rule("<", ">", "typescript"))
      npairs.add_rule(Rule("<", ">", "typescriptreact"))
      Map('i', 'х', 'х')
      Map('i', 'ъ', 'ъ')
      Map('i', 'э', 'э')
      Map('i', 'ё', 'ё')
    end
  }

  use 'tversteeg/registers.nvim'
  use {
    'phaazon/hop.nvim',
    as = 'hop',
    config = function()
      require'hop'.setup {}

      Map("n", "<leader>h", "<cmd>lua require'hop'.hint_words()<cr>")
      Map("n", "<leader>l", "<cmd>lua require'hop'.hint_words()<cr>")
      Map("n", "<leader>k", "<cmd>lua require'hop'.hint_lines()<cr>")
      Map("n", "<leader>j", "<cmd>lua require'hop'.hint_lines()<cr>")
      Map("n", "<leader>f", "<cmd>lua require'hop'.hint_char1()<cr>")
      Map("n", "<leader>s", "<cmd>lua require'hop'.hint_char2()<cr>")
    end
  }

  -- use 'fedorenchik/qt-support.vim'

  -- lsp configs
  -- use {
  --   'RishabhRD/nvim-lsputils',
  --   requires = { 'RishabhRD/popfix', opt = true },
  --   config = function()
  --     vim.lsp.handlers['textDocument/codeAction'] =
  --         require'lsputil.codeAction'.code_action_handler
  --     vim.lsp.handlers['textDocument/references'] =
  --         require'lsputil.locations'.references_handler
  --     vim.lsp.handlers['textDocument/definition'] =
  --         require'lsputil.locations'.definition_handler
  --     vim.lsp.handlers['textDocument/declaration'] =
  --         require'lsputil.locations'.declaration_handler
  --     vim.lsp.handlers['textDocument/typeDefinition'] =
  --         require'lsputil.locations'.typeDefinition_handler
  --     vim.lsp.handlers['textDocument/implementation'] =
  --         require'lsputil.locations'.implementation_handler
  --     vim.lsp.handlers['textDocument/documentSymbol'] =
  --         require'lsputil.symbols'.document_handler
  --     vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
  --   end
  -- }
  use { 'onsails/lspkind-nvim', config = function() require('lspkind').init() end }
  -- use 'ray-x/lsp_signature.nvim'
  -- use { 'nvim-lua/completion-nvim', opt = true }
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  -- use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  use 'folke/lsp-colors.nvim' -- enables colors to lsp, like warnings, errors

  -- TODO: load only on lua files
  use 'folke/lua-dev.nvim'

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        patterns = { ".git", "Makefile", "package.json", "init.lua" },
        detection_methods = { ".git", "Makefile", "package.json", "init.lua" },
        exclude_dirs = { "client" }
      }
    end
  }

  -- use 'jackguo380/vim-lsp-cxx-highlight'

  --   use {
  --     'simrat39/symbols-outline.nvim',
  --     config = function() Map('n', '<leader>;', ':SymbolsOutline<CR>') end
  --   }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd [[TSUpdate]] end,
    config = function()
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
          enable = true,
          disable = { "html" },
          extended_mode = true,
          colors = { "#bf616a", "#ffd700", "#a3de3c", "#ebcb8b", "#88c0d0" }
          -- colors = { "#d900ff", "#00ffd9", "#ffd700" }
        },

        context_commentstring = { enable = true, config = { fish = "# %s" } },

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
  }
  use 'p00f/nvim-ts-rainbow'
  -- use 'JoosepAlviste/nvim-ts-context-commentstring'
  use "windwp/nvim-ts-autotag"
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'RRethy/nvim-treesitter-textsubjects'
  -- use 'romgrk/nvim-treesitter-context'

  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        signs = false,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning", alt = { "FUCK", "SHIT", "BAD" } },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } }
        }
      }
    end
  }

  -- use {
  --   'andweeb/presence.nvim',
  --   config = function() require("presence"):setup({}) end
  -- }
end)
