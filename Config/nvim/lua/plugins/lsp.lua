local M = {
  'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
  event = { 'BufReadPre' }
}

M.dependencies = {
  'folke/lsp-colors.nvim', -- enables colors to lsp, like warnings, errors
  'hrsh7th/nvim-cmp', --
  'hrsh7th/cmp-nvim-lsp', --
  'L3MON4D3/LuaSnip', --
  --[['SmiteshP/nvim-navic',--]]

}

M.config = function()
  local nvim_lsp = require('lspconfig')
  local luasnip = require('luasnip')
  -- local root_pattern = require('util.root_pattern')

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  local on_attach = function(client, bufnr)
    -- require('lsp_signature').on_attach({
    --   bind = true,
    --   hint_enable = false,
    --   hi_parameter = "Todo",
    --   handler_opts = { border = "none" }
    -- })

    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menu,menuone,noinsert,noselect'
    -- nvim-cmp setup
    local cmp = require 'cmp'
    cmp.setup {
      snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(cmp.complete()),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
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

    -- vim.opt.completeopt = "menuone,noinsert,noselect"
    -- vim.g.completion_enable_auto_signature = 0
    -- vim.g.completion_enable_auto_popup = 0
    -- Cmd('imap <s-tab> <Plug>(completion_smart_s_tab)')
    -- Map('i', '<tab>', 'cmp.mapping.complete')
    -- Cmd('imap <c-space> <Plug>(completion_trigger)')
    -- vim.g.completion_matching_smart_case = 1
    -- vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy', 'all' }

    -- vim.g.completion_confirm_key = ''

    -- require('completion').on_attach()

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    -- buf_map('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>')
    Map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
    Map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
    Map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    Map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    Map('n', '<A-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    Map('n', '<leader>ha', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    Map('n', '<leader>hr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    Map('n', '<leader>hl',
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
    if client.server_capabilities.documentFormattingProvider then
      Map("n", "<leader>hf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
    elseif client.server_capabilities.documentFormattingProvider then
      Map("n", "<leader>hf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
    end
  end
  local servers = {
    "bashls", "vimls", "vuels", "tsserver", "yamlls", "jsonls", "cmake", "gopls", "cssls",
    "rust_analyzer", "pyright"
  }
  for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup { on_attach = on_attach } end

  vim.g.rust_recommended_style = 0;

  nvim_lsp.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "css", "typescriptreact", "javascriptreact" }
  })

  nvim_lsp.ccls.setup {
    on_attach = on_attach,
    cmd = { "ccls" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    single_file_support = true,
    init_options = {
      compilationDatabaseDirectory = "build",
      index = { threads = 0 },
      clang = {
        -- extraArgs = { "-std=c++20", "-Wall", "-Wno-logical-op-parentheses" },
        extraArgs = { "-Wall", "-Wno-logical-op-parentheses" },
        excludeArgs = { "-frounding-math" }
      },
      client = { snippetSupport = true }
    }
  }

  nvim_lsp.texlab.setup {
    settings = {
      latex = {
        build = {
          args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-outdir=./build", "%f" },
          outputDirectory = "./build",
          onSave = true
        },
        lint = { onChange = true }
      }
    },
    on_attach = on_attach
  }

  nvim_lsp.sumneko_lua.setup({
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        }
      }
    }
  })

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

return M
