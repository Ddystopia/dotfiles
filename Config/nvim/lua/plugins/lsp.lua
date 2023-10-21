require('utils')

local M = {
  -- Collection of configurations for built-in LSP client
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost' },
}

M.config = function()
  local nvim_lsp = require('lspconfig')
  local luasnip = require('luasnip')
  local on_attach = OnAttach
  local root_pattern = nvim_lsp.util.root_pattern

  require("luasnip.loaders.from_snipmate").lazy_load(
    { paths = { "./snippets" } })

  -- TODO: verify does it solves bug with random jumps on tab
  luasnip.config.set_config({
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
  })

  local configs = require('lspconfig.configs')
  if not configs.typst then
    configs.typst = {
      default_config = {
        cmd = { "typst-lsp" },
        filetypes = { "typ", "typst" },
        root_dir = function(fname)
          return root_pattern(".git")(fname) or vim.loop.os_homedir()
        end,
        settings = {}
      }
    }
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.offsetEncoding = { "utf-16" }
  capabilities.experimental = { localDocs = true }

  local servers = {
    "zls", "bashls", "tsserver", "yamlls", "jsonls", "gopls", "cssls",
    "html" -- "cmake", "vuels", "vimls",
  }

  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      single_file_support = true
    }
  end

  nvim_lsp.typst.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      exportPdf = "onType"
      -- exportPdf = "onSave",
      -- exportPdf = "never",
    }
  }

  -- nvim_lsp.flake8.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   settings = {
  --     -- flake8 = {
  --     --   ignore = { "E501", "E402", "E203", "E231", "E128", "E124", "E127" },
  --     --   max_line_length = 120
  --     -- }
  --   }
  -- }

  -- vim.g.rust_recommended_style = 0;
  vim.g.rust_recommended_style = 1;

  nvim_lsp.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    -- cmd = { "ra-multiplex", "client" },
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        -- hoverActions = { linksInHover = true },
        diagnostics = {
          enable = true,
          disabled = { "inactive-code" },
          enableExperimental = true
        },
        checkOnSave = {
          allFeatures = true,
          overrideCommand = {
            'cargo', 'clippy', '--workspace', '--message-format=json',
            '--all-targets', '--all-features', '--',
            -- '-W', 'clippy::unwrap-used',
            '-W', 'clippy::use_self',
            '-W', 'clippy::pedantic',
            '-W', 'clippy::perf',
            '-W', 'clippy::missing-assert-message',

            '-A', 'clippy::module-name-repetitions',
            '-A', 'clippy::default-trait-access',
            '-A', 'clippy::similar-names',
            '-A', 'clippy::manual-assert',
            '-A', 'clippy::cast-possible-truncation',
            '-A', 'clippy::cast-sign-loss',
            '-A', 'clippy::cast-lossless',
            '-A', 'clippy::redundant-closure-for-method-calls',
            '-A', 'clippy::redundant_closure',
            '-A', 'clippy::single-match-else',
            '-A', 'clippy::too-many-lines',
            '-A', 'clippy::cast-precision-loss',
            '-A', 'clippy::match-bool',
          }
        }
      }
    }
  }

  nvim_lsp.java_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "java-language-server" },
    filetypes = { "java" }
    -- settings = {},
  }

  nvim_lsp.ccls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "ccls" },
    filetypes = { "cpp", "objc", "objcpp" },
    single_file_support = true,
    init_options = {
      compilationDatabaseDirectory = "build",
      index = { threads = 0 },
      cache = { directory = os.getenv("XDG_CACHE_HOME") .. "/ccls" },
      clang = {
        extraArgs = {
          "-std=c++20", "-Wall", "-Wextra", "-Wno-logical-op-parentheses"
        },
        -- extraArgs = { "-Wall", "-Wextra", "-Wno-logical-op-parentheses" },
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

  nvim_lsp.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c" },
    cmd = {
      'clangd', '--header-insertion=never', '--suggest-missing-includes',
      '--background-index', '-j=8', '--cross-file-rename',
      '--pch-storage=memory', '--clang-tidy', -- '-std=c++17',
      '--clang-tidy-checks=-clang-analyzer-*,bugprone-*,misc-*,-misc-non-private-member-variables-in-classes,performance-*,-performance-no-automatic-move,modernize-use-*,-modernize-use-nodiscard,-modernize-use-trailing-return-type'
    },
    -- on_init = require'clangd_nvim'.on_init,
    -- callbacks = lsp_status.extensions.clangd.setup(),
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true
    }
  }

  --[[
  nvim_lsp.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "css", "typescriptreact", "javascriptreact" }
  })
  --]]
end

M.init = function()
  -- Mappings
  Map('n', 'gD', function() vim.lsp.buf.declaration() end)
  Map('n', 'gd', function() vim.lsp.buf.definition() end)
  Map('n', 'gt', function() vim.lsp.buf.type_definition() end)
  Map('n', 'gi', function() vim.lsp.buf.implementation() end) -- lspsaga
  Map('n', 'gr', function() vim.lsp.buf.references() end) -- lspsaga

  Map('n', 'K', function() vim.lsp.buf.hover() end)
  Map('n', '<F2>', function() vim.lsp.buf.rename() end)
  Map('n', '<leader>a', function() vim.lsp.buf.code_action() end)
  Map('v', '<leader>a', function() vim.lsp.buf.code_action() end)
  -- Map('n', '<leader>D', function () vim.lsp.buf.type_definition() end)

  Map('n', '<leader>e', function() vim.diagnostic.open_float() end)
  Map('n', '[d', function() vim.diagnostic.goto_prev() end)
  Map('n', ']d', function() vim.diagnostic.goto_next() end)
  Map('n', '<leader>q', function() vim.diagnostic.setloclist() end)
  Map('n', '<leader>rn', function() vim.lsp.buf.rename() end)

  local function open_local_docs(_, url)
    if url == nil then
      print("nil")
      return
    end
    vim.fn["netrw#BrowseX"](url["local"], 0)
  end

  Map('n', '<leader>rd', function()
    vim.lsp.buf_request(0, "experimental/externalDocs",
      vim.lsp.util.make_position_params(), open_local_docs)
  end)
  Map('v', '<leader>rd', function()
    vim.lsp.buf_request(0, "experimental/externalDocs",
      vim.lsp.util.make_position_params(), open_local_docs)
  end)

  -- Map('n', '<leader>ha', function () vim.lsp.buf.add_workspace_folder() end)
  -- Map('n', '<leader>hr', function () vim.lsp.buf.remove_workspace_folder() end)
  -- Map('n', '<leader>hl',
  --     function () print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)

  -- Map('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>')
  -- Map('n', '<A-k>', function () vim.lsp.buf.signature_help() end)
end
M.dependencies = {
  'hrsh7th/nvim-cmp',     --
  'hrsh7th/cmp-path',     --
  'hrsh7th/cmp-nvim-lsp', --
  'onsails/lspkind-nvim', --
  -- 'SmiteshP/nvim-navic',
  {
    "L3MON4D3/LuaSnip",
    dependencies = "saadparwaiz1/cmp_luasnip",
    build = "make install_jsregexp"
  }, {
  'RishabhRD/nvim-lsputils',
  enable = false,
  dependencies = { 'RishabhRD/popfix' },
  config = function()
    vim.lsp.handlers['textDocument/codeAction'] =
        require 'lsputil.codeAction'.code_action_handler
    vim.lsp.handlers['textDocument/references'] =
        require 'lsputil.locations'.references_handler
    vim.lsp.handlers['textDocument/definition'] =
        require 'lsputil.locations'.definition_handler
    vim.lsp.handlers['textDocument/declaration'] =
        require 'lsputil.locations'.declaration_handler
    vim.lsp.handlers['textDocument/typeDefinition'] =
        require 'lsputil.locations'.typeDefinition_handler
    vim.lsp.handlers['textDocument/implementation'] =
        require 'lsputil.locations'.implementation_handler
    vim.lsp.handlers['textDocument/documentSymbol'] =
        require 'lsputil.symbols'.document_handler
    vim.lsp.handlers['workspace/symbol'] =
        require 'lsputil.symbols'.workspace_handler
  end
}
}

return {
  M,
  -- lsp for nvim config
  { 'folke/neodev.nvim', ft = { 'lua' }, config = true },
}
