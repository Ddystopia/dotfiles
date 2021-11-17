vim.cmd('packadd packer.nvim')

Map('n', '<leader>PP', ':PackerCompile<CR>')
Map('n', '<leader>PS', ':PackerSync<CR>')

local packer = require('packer')
return packer.startup(function()
  local use = packer.use

  use { 'wbthomason/packer.nvim', opt = true }
  use 'folke/lua-dev.nvim'
  use 'folke/lsp-colors.nvim'
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
    "hoob3rt/lualine.nvim",
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local function keymap()
        if vim.bo.iminsert == 0 then
          return [[us]]
        else
          return [[ru]]
        end
      end

      require('lualine').setup {
        options = {
          theme = 'dracula',
          section_separators = { '', '' },
          component_separators = { '|', '|' },
          icons_enabled = true
        },
        sections = {
          lualine_a = { 'mode' },
          -- lualine_a = { 'mode', keymap },
          lualine_b = { 'branch', 'diff' },
          lualine_c = {
            'filename', {
              'diagnostics',
              sources = { 'nvim_lsp' },
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
  }
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      local b = require("bufferline")
      b.setup {
        options = {
          mappings = false,
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          always_show_bufferline = false
        },
        highlights = {
          fill = { guibg = '#21222C' },
          buffer_selected = { gui = 'bold' }
        }
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
      vim.g.XkbSwitchIMappings = {'ru'}
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
      vim.g.indent_blankline_filetype_exclude =
          { 'markdown', 'tex', 'startify' }
    end
  }
  use {
    'machakann/vim-highlightedyank',
    config = function() vim.g.highlightedyank_highlight_duration = 250 end
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        '*',
        css = { css = true },
        scss = { scc = true }
      }, { names = false })
    end
  }

  use { 'NFrid/due.nvim', config = function() require('due_nvim').setup {} end }

  use {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_lists = {
        { type = 'dir', header = { "MRU [" .. vim.fn.getcwd() .. "]" } },
        { type = 'files', header = { "MRU [global]" } }
      }
      vim.g.startify_fortune_use_unicode = 1
      -- vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
      Map('n', '<leader>s', ':Startify<CR>')
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
  use 'lervag/vimtex'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
    config = function()
      require('telescope').setup {}
      Map('n', '<leader>t', '<cmd>Telescope<CR>')
      Map('n', '<leader>f', '<cmd>lua require("telescope.builtin").fd()<CR>')
      Map('n', '<leader>o',
          '<cmd>lua require("telescope.builtin").buffers()<CR>')
      Map('n', '<leader>m', '<cmd>lua require("telescope.builtin").marks()<CR>')
      Map('n', '<leader>r',
          '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>')
      Map('n', '<leader>R',
          '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>')
      Map('n', '<C-f>',
          '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>')
      Map('n', '<F1>', '<cmd>lua require("telescope.builtin").commands()<CR>')
      Map('n', '<leader>d',
          '<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<CR>')
      Map('n', '<leader>u', ':TodoTelescope<CR>')
    end
  }

  use {
    'tpope/vim-commentary',
    config = function() Cmd "au FileType apache setlocal commentstring=#%s" end
  }
  use 'tpope/vim-surround'
  use 'kana/vim-repeat'
  use 'jiangmiao/auto-pairs'

  use 'tversteeg/registers.nvim'
  use {
    'phaazon/hop.nvim',
    as = 'hop',
    config = function()
      require'hop'.setup {}

      Map('n', 's', '<NOP>')
      Map("n", "sh", "<cmd>lua require'hop'.hint_words()<cr>")
      Map("n", "sl", "<cmd>lua require'hop'.hint_words()<cr>")
      Map("n", "sk", "<cmd>lua require'hop'.hint_lines()<cr>")
      Map("n", "sj", "<cmd>lua require'hop'.hint_lines()<cr>")
      Map("n", "sf", "<cmd>lua require'hop'.hint_char1()<cr>")
      Map("n", "ss", "<cmd>lua require'hop'.hint_char2()<cr>")
    end
  }

  use 'fedorenchik/qt-support.vim'

  use {
    'mattn/emmet-vim',
    config = function()
      vim.g.user_emmet_mode = 'i'
      vim.g.user_emmet_leader_key = '<A-m>'
    end
  }
  use {
    'RishabhRD/nvim-lsputils',
    requires = { 'RishabhRD/popfix', opt = true },
    config = function()
      vim.lsp.handlers['textDocument/codeAction'] =
          require'lsputil.codeAction'.code_action_handler
      vim.lsp.handlers['textDocument/references'] =
          require'lsputil.locations'.references_handler
      vim.lsp.handlers['textDocument/definition'] =
          require'lsputil.locations'.definition_handler
      vim.lsp.handlers['textDocument/declaration'] =
          require'lsputil.locations'.declaration_handler
      vim.lsp.handlers['textDocument/typeDefinition'] =
          require'lsputil.locations'.typeDefinition_handler
      vim.lsp.handlers['textDocument/implementation'] =
          require'lsputil.locations'.implementation_handler
      vim.lsp.handlers['textDocument/documentSymbol'] =
          require'lsputil.symbols'.document_handler
      vim.lsp.handlers['workspace/symbol'] =
          require'lsputil.symbols'.workspace_handler
    end
  }
  use {
    'onsails/lspkind-nvim',
    config = function() require('lspkind').init() end
  }
  use 'ray-x/lsp_signature.nvim'
  use {
    'neovim/nvim-lspconfig',
    requires = { 'nvim-lua/completion-nvim', opt = true },
    config = function()
      local nvim_lsp = require('lspconfig')

      local on_attach = function(client, bufnr)
        -- require('lsp_signature').on_attach(
        --     {
        --       bind = true,
        --       hint_enable = false,
        --       hi_parameter = "Todo",
        --       handler_opts = { border = "none" }
        --     })

        vim.opt.completeopt = "menuone,noinsert,noselect"
        vim.g.completion_enable_auto_signature = 0
        vim.g.completion_enable_auto_popup = 0
        Cmd('imap <tab> <Plug>(completion_smart_tab)')
        Cmd('imap <s-tab> <Plug>(completion_smart_s_tab)')
        Cmd('imap <c-space> <Plug>(completion_trigger)')
        vim.g.completion_matching_smart_case = 1
        vim.g.completion_matching_strategy_list = {
          'exact', 'substring', 'fuzzy', 'all'
        }

        vim.g.completion_confirm_key = ''

        require('completion').on_attach()

        local function buf_map(mode, keys, action)
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(bufnr, mode, keys, action, opts)
        end
        local function buf_set(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        -- buf_map('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>')
        buf_map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
        buf_map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
        buf_map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
        buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        buf_map('n', '<A-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

        buf_map('n', '<leader>la',
                '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        buf_map('n', '<leader>lr',
                '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        buf_map('n', '<leader>ll',
                '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

        -- buf_map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        buf_map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
        buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        buf_map('n', '<leader>a', '<Cmd>lua vim.lsp.buf.code_action()<CR>')

        buf_map('n', '<leader>e',
                '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
        buf_map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
        buf_map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
        buf_map('n', '<leader>q',
                '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
          buf_map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
        elseif client.resolved_capabilities.document_range_formatting then
          buf_map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
        end
      end

      local servers = {
        "bashls", "vimls", "tsserver", "vuels", "yamlls", "jsonls", "cmake",
        "gopls", "cssls", "html", "rust_analyzer"
      }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup { on_attach = on_attach }
      end

      local eslint = {
        lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
        lintStdin = true,
        lintFormats = { "%f:%l:%c: %m" },
        lintIgnoreExitCode = true,
        formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
        formatStdin = true
      }

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

      nvim_lsp.clangd.setup {
        cmd = {
          'clangd', '--header-insertion=never', '--suggest-missing-includes',
          '--background-index', '-j=8', '--cross-file-rename',
          '--pch-storage=memory', '--clang-tidy',
          '--clang-tidy-checks=-clang-analyzer-*,bugprone-*,misc-*,-misc-non-private-member-variables-in-classes,performance-*,-performance-no-automatic-move,modernize-use-*,-modernize-use-nodiscard,-modernize-use-trailing-return-type'
        },
        -- on_init = require'clangd_nvim'.on_init,
        -- callbacks = lsp_status.extensions.clangd.setup(),
        capabilities = {
          capabilities = { window = { workDoneProgress = true } },
          textDocument = {
            completion = { completionItem = { snippetSupport = true } },
            semanticHighlightingCapabilities = { semanticHighlighting = true }
          }
        },
        init_options = {
          clangdFileStatus = true,
          usePlaceholders = true,
          completeUnimported = true
        },
        on_attach = function() end
      }

      nvim_lsp.efm.setup {
        -- root_dir = function()
        --   if not eslint_config_exists() then
        --     return nil
        --   end
        --   return vim.fn.getcwd()
        -- end,
        settings = {
          languages = {
            javascript = { eslint },
            javascriptreact = { eslint },
            ["javascript.jsx"] = { eslint },
            typescript = { eslint },
            ["typescript.tsx"] = { eslint },
            typescriptreact = { eslint }
          }
        },
        filetypes = {
          "javascript", "javascriptreact", "javascript.jsx", "typescript",
          "typescript.tsx", "typescriptreact"
        },
        on_attach = on_attach
      }

      nvim_lsp.texlab.setup {
        settings = {
          latex = {
            build = {
              args = {
                "-pdf", "-interaction=nonstopmode", "-synctex=1",
                "-outdir=./build", "%f"
              },
              outputDirectory = "./build",
              onSave = true
            },
            lint = { onChange = true }
          }
        },
        on_attach = on_attach
      }

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
      local luadev = require("lua-dev").setup({
        library = { vimruntime = false },
        lspconfig = {
          cmd = { "/usr/bin/lua-language-server" },
          on_attach = on_attach
        }
      })
      nvim_lsp.sumneko_lua.setup(luadev)
    end
  }

  use {
    "ahmedkhalf/lsp-rooter.nvim",
    config = function() require("lsp-rooter").setup {} end
  }

  use 'jackguo380/vim-lsp-cxx-highlight'

  use {
    'simrat39/symbols-outline.nvim',
    config = function() Map('n', '<leader>;', ':SymbolsOutline<CR>') end
  }

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
        },

        context_commentstring = { enable = true, config = { fish = "# %s" } },

        autotag = { enable = true },

        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner"
            }
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>."] = "@parameter.inner" },
            swap_previous = { ["<leader>,"] = "@parameter.inner" }
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer"
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer"
            },
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
  }
  use "p00f/nvim-ts-rainbow"
  use "JoosepAlviste/nvim-ts-context-commentstring"
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
          HACK = {
            icon = " ",
            color = "warning",
            alt = { "FUCK", "SHIT", "BAD" }
          },
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
