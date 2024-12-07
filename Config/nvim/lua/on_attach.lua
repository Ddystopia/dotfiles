--- comment
--- @param specific function
--- @return function
function OnAttach(specific)
  return function(client, bufnr)
    OnAttachCommon(client, bufnr)
    specific(client, bufnr)
  end
end

function OnAttachCommon(client, bufnr)
  --[[
    require "lsp_signature".on_attach({
      bind = true,
      hint_enable = false,
      fix_pos = true,
      doc_lines = 20,
      handler_opts = {
        border = vim.g.float_border,
      }
    }, bufnr);
  --]]

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

  local try_confirm_with_fallback = function(char)
    return function(fallback)
      if cmp.visible() and cmp.get_selected_entry() ~= nil then
        cmp.confirm()

       vim.defer_fn(function()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_get_current_line()
          local new_line = line:sub(1, col) .. char .. line:sub(col + 1)
          vim.api.nvim_set_current_line(new_line)
          vim.api.nvim_win_set_cursor(0, { row, col + 1 })
        end, 0)
      end

      fallback()
    end
  end

  local mapping = {
    ['<C-p>'] = function() cmp.select_prev_item() end,
    ['<C-n>'] = function() cmp.select_next_item() end,
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
  };

  mapping[':'] = try_confirm_with_fallback(':')

  cmp.setup {
    experimental = { ghost_text = true },
    sorting = {
      priority_weight = 2,
      comparators = {
        function(e1, e2)
          local e1_has = e1 and e1.completion_item and e1.completion_item.data and e1.completion_item.data.imports and
              #e1.completion_item.data.imports > 0
          local e2_has = e2 and e2.completion_item and e2.completion_item.data and e2.completion_item.data.imports and
              #e2.completion_item.data.imports > 0

          if e1_has and not e2_has then
            return false
          elseif not e1_has and e2_has then
            return true
          end

          return nil
        end,
        require('copilot_cmp.comparators').prioritize,
        require('copilot_cmp.comparators').score,
        -- compare.recently_used,
        -- compare.locality,
        -- compare.scopes,
        compare.exact,
        compare.sort_text,
        compare.offset,
        compare.length,
        compare.order,
      }
    },
    matching = {
      disallow_fuzzy_matching = false,
      disallow_fullfuzzy_matching = false,
      disallow_partial_fuzzy_matching = false,
      disallow_partial_matching = false,
      disallow_prefix_unmatching = false,
      disallow_symbol_nonprefix_matching = false,
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
    mapping = mapping,
  }

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    Map("n", "<leader>hf", function() vim.lsp.buf.format({ async = true }) end)
  end
end
