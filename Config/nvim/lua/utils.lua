Map = function(mode, key, cmd, opts)
  local options = { noremap = true, silent = true }
  if type(cmd) == "function" then
    options.callback = cmd
    cmd = ""
  end
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, key, cmd, options)
end

BMap = function(mode, key, cmd, opts)
  local options = { noremap = true, silent = true }
  if type(cmd) == "function" then
    options.callback = cmd
    cmd = ""
  end
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_buf_set_keymap(0, mode, key, cmd, options)
end

Cmd = vim.api.nvim_command

Sad = function(line_nr, from, to, fname)
  local template = "silent !sed -i '%s\\!b;s/%s/%s/' %s"
  vim.cmd(string.format(template, line_nr, from, to, fname))
end

IncreasePadding = function()
  -- Sad(6, 3, 4, '~/.config/alacritty/alacritty.yml')
  -- Sad(7, 3, 4, '~/.config/alacritty/alacritty.yml')
end

DecreasePadding = function()
  -- Sad(6, 4, 3, '~/.config/alacritty/alacritty.yml')
  -- Sad(7, 4, 3, '~/.config/alacritty/alacritty.yml')
end

On_attach = function(client, bufnr)
  local lspkind = require('lspkind')
  local luasnip = require('luasnip')
    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menu,menuone,noinsert,noselect'
    -- nvim-cmp setup
    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end

      local line = vim.api.nvim_win_get_cursor(0)[1]
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local lines = vim.api.nvim_buf_get_lines(0, line - 1, line, true);
      return col ~= 0 and lines[1]:match("^%s*$") == nil
    end

    local cmp = require 'cmp'
    cmp.setup {
      experimental = { ghost_text = true },
      snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
      },
      sources = {
        { name = 'copilot' }, { name = 'path' }, { name = 'nvim_lsp' },
        { name = 'luasnip' }
      },
      -- sources = cmp.config.sources(
      --     { { name = 'nvim_lsp' }, { name = 'luasnip' } },
      --     { --[[{ name = 'buffer' } --]] }),
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        },
        ['<C-space>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        },
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
      -- completion = { autocomplete = false },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 60, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          before = function(_, vim_item) return vim_item end,
          symbol_map = { Copilot = "" }
        })
      }
    }

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.documentFormattingProvider then
      Map("n", "<leader>hf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
    end
  end
