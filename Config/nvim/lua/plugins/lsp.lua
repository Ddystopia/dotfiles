require('utils')

local M = {
  -- Collection of configurations for built-in LSP client
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost' },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust', 'toml' },
  desc = 'Set errorformat for cargo output',
  callback = function()
    vim.opt.errorformat = ({
      '%Eerror%*[^\\ ]:\\ %m',     -- Start of a multi-line error (e.g., error[E0432]: ...)
      '%Wwarning%*[^\\ ]:\\ %m',  -- Start of a multi-line warning
      '%C%*\\s-->\\ %f:%l:%c',     -- Location info (file, line, col)
      '%-G%.%#',                  -- Ignore all other lines
    })
  end,
})

M.config = function()
  local luasnip = require('luasnip')
  local on_attach = OnAttachCommon

  -- vim.lsp.inlay_hint.enable()

  -- require("luasnip.loaders.from_snipmate").lazy_load(
  --   { paths = { "./snippets" } })

  luasnip.config.set_config({
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
  })

  local function default_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    -- todo: is it clang or ccls?
    capabilities.offsetEncoding = { "utf-16" }
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    return capabilities
  end

  local capabilities = default_capabilities()

  local servers = {
    "zls", "bashls", "ts_ls", "gopls", "cssls", "pyright",
    "html", "r_language_server" -- "jsonls", "cmake", "vuels", "vimls", "yamlls"
    -- maybe `air` for R
  }

  vim.lsp.config("*", {
    on_attach = on_attach,
    capabilities = capabilities,
    root_marker = { ".git", ".project_root" },
    single_file_support = true
  })

  for _, lsp in ipairs(servers) do
    vim.lsp.enable(lsp)
  end

  vim.lsp.config('typst', {
    cmd = { "tinymist" },
    filetypes = { "typ", "typst" },
    root_marker = { "typst.toml" },
    settings = {}
  })

  vim.g.rust_recommended_style = 1;

  vim.lsp.config.rust_analyzer = {
    on_attach = on_attach,
    -- cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
    cmd = { "rust-analyzer" },
    capabilities = (function()
      local fresh = default_capabilities();
      -- fresh.textDocument.completion.completionItem.snippetSupport = true
      fresh.experimental = { localDocs = true }
      return fresh;
    end)(),
    init_options = {
      lspMux = {
        version = "1",
        method = "connect",
        server = "rust-analyzer",
      },
    },
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          buildScripts = { enable = true },
          -- target = "wasm32-unknown-unknown",
          -- target = "thumbv7em-none-eabihf",
        },
        editor = {
          formatOnType = true,
        },
        completion = {
          limit = 20,
          termSearch = { enable = true },
          postfix = { enable = false }
        },
        hover = {
          memoryLayout = {
            niches = true
          },
          show = {
            fields = 20,
            traitAssocItems = 10,
          },
        },
        -- lru = {
        --   capacity = 512,
        -- },
        -- hoverActions = { linksInHover = true },
        diagnostics = {
          enable = true,
          -- disabled = { "inactive-code" },
          enableExperimental = false
        },
        typing = {
          autoClosingAngleBrackets = { enable = true }
        },
        checkOnSave = false,
        -- checkOnSave = {
        --   overrideCommand = {
        --     'cargo', 'clippy', '--workspace', '--message-format=json',
        --     '--all-targets', -- '--all-features'
        --   }
        -- },
      }
    }
  }
  vim.lsp.enable('rust_analyzer')

  vim.lsp.config('java_language_server', {
    cmd = { "java-language-server" },
    filetypes = { "java" }
  })
  vim.lsp.enable('java_language_server')

  vim.lsp.config('ccls', {
    cmd = { "ccls" },
    filetypes = { "cpp", "objc", "objcpp" },
    single_file_support = true,
    init_options = {
      compilationDatabaseDirectory = "build",
      index = { threads = 0 },
      cache = { directory = vim.fn.stdpath('cache') .. "/ccls" },
      clang = {
        extraArgs = {
          "-std=c++23", "-Wall", "-Wextra", "-Wno-logical-op-parentheses"
        },
        -- extraArgs = { "-Wall", "-Wextra", "-Wno-logical-op-parentheses" },
        excludeArgs = { "-frounding-math" }
      },
      client = { snippetSupport = true }
    }
  })
  vim.lsp.enable('ccls')

  vim.lsp.config('gopls', {
    -- handler = handlers,
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  })

  vim.lsp.enable('lua_ls')
  vim.lsp.config('lua_ls', {
    filetypes = { "lua" },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = { globals = { 'vim' } },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
        library = { vim.env.VIMRUNTIME }
      },
    }
  })

  vim.lsp.config('clangd', {
    filetypes = { "c" },
    cmd = {
      'clangd', '--header-insertion=never', '--suggest-missing-includes',
      '--background-index', '-j=8', '--cross-file-rename',
      '--pch-storage=memory', '--clang-tidy', -- '-std=c11',
      '--clang-tidy-checks=-clang-analyzer-*,bugprone-*,misc-*,-misc-non-private-member-variables-in-classes,performance-*,-performance-no-automatic-move,modernize-use-*,-modernize-use-nodiscard,-modernize-use-trailing-return-type',
      '--compile-commands-dir=build'
    },
    -- on_init = require'clangd_nvim'.on_init,
    -- callbacks = lsp_status.extensions.clangd.setup(),
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true
    }
  })
  vim.lsp.enable('clangd')
end

M.init = function()
  -- Mappings
  Map('n', 'gD', function() vim.lsp.buf.declaration() end)
  Map('n', 'gd', function() vim.lsp.buf.definition() end)
  Map('n', 'gt', function() vim.lsp.buf.type_definition() end)
  Map('n', 'gI', function() vim.lsp.buf.implementation() end) -- todo: lspsaga
  Map('n', 'gr', function() vim.lsp.buf.references() end)     -- todo: lspsaga

  vim.keymap.del('n', 'gri')
  vim.keymap.del('n', 'grr')
  vim.keymap.del('n', 'grt')
  vim.keymap.del('n', 'gra')
  vim.keymap.del('n', 'grn')

  Map('n', 'K', function() vim.lsp.buf.hover({ float = { border = 'single' } }) end)
  Map('n', '<F2>', function() vim.lsp.buf.rename() end)
  Map('n', '<leader>a', function() vim.lsp.buf.code_action() end)
  Map('v', '<leader>a', function() vim.lsp.buf.code_action() end)

  -- Opens a popup that displays signature for the function's param under your cursor.
  Map('i', '<C-k>', vim.lsp.buf.signature_help)
  -- Map('n', '<leader>D', function () vim.lsp.buf.type_definition() end)

  Map('n', '<leader>e', function() vim.diagnostic.open_float() end)
  Map('n', '[d', function() vim.diagnostic.goto_prev() end)
  Map('n', ']d', function() vim.diagnostic.goto_next() end)
  Map('n', '<leader>q', function() vim.diagnostic.setloclist() end)
  Map('n', '<leader>rn', function() vim.lsp.buf.rename() end)

  local function open_local_docs(_, url)
    if url == nil or url["local"] == nil then
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
  {
    'hrsh7th/nvim-cmp', --
    -- commit = "d818fd0",
    commit = "f17d9b4",
    pin = true,
  }, --
  {
    'ray-x/lsp_signature.nvim',
    enabled = false,
    lazy = false,
  },
  'hrsh7th/cmp-path',     --
  'hrsh7th/cmp-nvim-lsp', --
  'onsails/lspkind-nvim', -- adds vscode-like pictograms to neovim built-in lsp
  -- 'SmiteshP/nvim-navic',
  {
    'folke/neoconf.nvim',
    lazy = false,
    config = function()
      require('neoconf').setup({})
    end
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = "saadparwaiz1/cmp_luasnip",
    build = "make install_jsregexp",
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

  {
    'tomtomjhj/coq-lsp.nvim',
    -- ft = { "coq" },
    lazy = false,
    enabled = false,
    config = function()
      require 'coq-lsp'.setup {
        -- The configuration for coq-lsp.nvim.
        -- The following is the default configuration.
        coq_lsp_nvim = {
          -- to be added
        },

        -- The configuration forwarded to `:help lspconfig-setup`.
        -- The following is an example.
        lsp = {
          on_attach = OnAttach,
          -- coq-lsp server initialization configurations, defined here:
          -- https://github.com/ejgallego/coq-lsp/blob/main/editor/code/src/config.ts#L3
          -- Documentations are at https://github.com/ejgallego/coq-lsp/blob/main/editor/code/package.json.
          init_options = {
            show_notices_as_diagnostics = true,
          },
          autostart = true, -- use this if you want to manually launch coq-lsp with :LspStart.
        },
      }
    end
  },
}
