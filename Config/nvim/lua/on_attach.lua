function OnAttach(client, bufnr)
  -- client.server_capabilities.semanticTokensProvider = nil
  local lspkind = require('lspkind')
  local luasnip = require('luasnip')
  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menu,menuone,noinsert,noselect'

  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end

    local line = vim.api.nvim_win_get_cursor(0)[1]
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local lines = vim.api.nvim_buf_get_lines(0, line - 1, line, true);
    return col > 0 and lines[1]:sub(1, col):match("^%s*$") == nil
  end

  local cmp = require 'cmp'
  local compare = cmp.config.compare
  local types = require('cmp.types')

  require "lsp_signature".on_attach({
    bind = true,
    hint_enable = false,
    fix_pos = true,
    doc_lines = 20,
    handler_opts = {
      border = vim.g.float_border,
    }
  }, bufnr);

  cmp.setup {
    experimental = { ghost_text = true },
    sorting = {
      priority_weight = 2,
      comparators = {
        require('copilot_cmp.comparators').prioritize,
        compare.order,
        compare.exact,
        compare.offset,
        compare.sort_text,
        compare.length,
      }
    },
    window = {
      documentation = {
        border = vim.g.float_border,
      }
    },
    snippet = {
      expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    sources = {
      { name = 'copilot' }, { name = 'path' }, { name = 'nvim_lsp' },
      { name = 'luasnip' }
    },
    preselect = types.cmp.PreselectMode.None,
    -- completion = { autocomplete = false },
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol',       -- show only symbol annotations
        maxwidth = 30,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        before = function(_, vim_item) return vim_item end,
        symbol_map = { Copilot = "" }
      })
    },
    mapping = {
      ['<C-p>'] = function()
        cmp.select_prev_item()
      end,
      ['<C-n>'] = function()
        cmp.select_next_item()
      end,
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = function(fallback)
        if cmp.visible() and cmp.get_selected_entry() ~= nil then
          cmp.confirm()
        else
          fallback()
        end
      end,
      ['<C-space>'] = function()
        if cmp.visible() then
          cmp.confirm()
        else
          cmp.complete()
        end
      end,
      ['<Tab>'] = function(fallback)
        if cmp.visible() and not luasnip.in_snippet() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() and not luasnip.in_snippet() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    },
  }

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    Map("n", "<leader>hf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
  end
end
