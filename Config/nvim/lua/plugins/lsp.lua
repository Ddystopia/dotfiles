local M = { -- Collection of configurations for built-in LSP client
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost' }
}

M.dependencies = {
  'hrsh7th/nvim-cmp', --
  'hrsh7th/cmp-nvim-lsp', --
  'onsails/lspkind-nvim', --
  -- 'SmiteshP/nvim-navic',
  {
    "L3MON4D3/LuaSnip",
    dependencies = "saadparwaiz1/cmp_luasnip",
    build = "make install_jsregexp"
  }

}

M.init = function()
  -- Mappings
  Map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  Map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  Map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  Map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

  Map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  Map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
  Map('n', '<leader>a', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  -- Map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

  Map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  Map('n', '[d', '<cmd>lua vim.diagnostic.get_prev()<CR>')
  Map('n', ']d', '<cmd>lua vim.diagnostic.get_next()<CR>')
  Map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

  -- Map('n', '<leader>ha', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  -- Map('n', '<leader>hr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  -- Map('n', '<leader>hl',
  --     '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

  -- Map('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>')
  -- Map('n', '<A-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
end

M.config = function()
  local nvim_lsp = require('lspconfig')
  local luasnip = require('luasnip')
  require("luasnip.loaders.from_snipmate").lazy_load({
    paths = { "./snippets" }
  })
  -- local root_pattern = require('util.root_pattern')

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  local lspkind = require('lspkind')

  local on_attach = function(client, bufnr)

    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menu,menuone,noinsert,noselect'
    -- nvim-cmp setup
    local cmp = require 'cmp'
    cmp.setup {
      snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
      },
      -- sources = { { name = 'nvim_lsp' }, { name = 'luasnip' } },
      sources = cmp.config.sources(
          { { name = 'nvim_lsp' }, { name = 'luasnip' } },
          { { name = 'buffer' } }),
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(cmp.complete()),
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
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          before = function(_, vim_item) return vim_item end
        })
      }
    }

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.documentFormattingProvider then
      Map("n", "<leader>hf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
    end
  end
  local servers = {
    "bashls", "tsserver", "yamlls", "jsonls", "gopls", "cssls", "rust_analyzer",
    "pyright", "html" -- "cmake", "vuels", "vimls",
  }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach, capabilities = capabilities }
  end

  vim.g.rust_recommended_style = 0;

  --[[
  nvim_lsp.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "css", "typescriptreact", "javascriptreact" }
  })
  --]]

  nvim_lsp.ccls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
    capabilities = capabilities,
    settings = {
      latex = {
        build = {
          args = {
            "-pdf", "-interaction=nonstopmode", "-synctex=1", "-outdir=./build",
            "%f"
          },
          outputDirectory = "./build",
          onSave = true
        },
        lint = { onChange = true }
      }
    },
    on_attach = on_attach
  }

  nvim_lsp.sumneko_lua.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        completion = { callSnippet = "Replace" }
      }
    }
  })

  --[[
  nvim_lsp.clangd.setup {
    cmd = {
      'clangd', '--header-insertion=never', '--suggest-missing-includes',
      '--background-index', '-j=8', '--cross-file-rename',
      '--pch-storage=memory', '--clang-tidy', -- '-std=c++17',
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
  --]]

end

--[[ {
    'RishabhRD/nvim-lsputils',
    dependencies = { 'RishabhRD/popfix', lazy = true },
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
      vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
    end
  } --]]
return M
