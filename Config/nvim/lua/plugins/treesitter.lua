local ensure_installed = {
  'rust', 'c', 'cpp', --[['javascript',]] 'lua', --[['python',]] 'bash',
  --[['fish',]] --[['html',]] 'css', 'dockerfile', 'diff', 'fish', 'go',
  'json', 'make', 'markdown', 'regex', -- 'scheme',
  'sxhkdrc', 'typescript', --[['yaml',]] 'zig', 'tsx', 'sql',
}

local M = {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  version = false,
  lazy = false,
  enabled = true,
  cond = function()
    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
      local filename = vim.api.nvim_buf_get_name(buf_id)
      local lines = vim.api.nvim_buf_line_count(buf_id)
      if vim.fn.getfsize(filename) > 100 * 1024 and lines > 0 then
        return false
      end
    end
    return true
  end,
  build = ':TSUpdate',
}

M.dependencies = {
  -- { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main', lazy = false },
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = false },
  {
    'HiPhish/rainbow-delimiters.nvim',
    lazy = false,
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = 'rainbow-delimiters.strategy.global',
          vim = 'rainbow.delimiters.strategy.local',
        },
        query = {
          -- global = 'rainbow-delimiters',
          -- html = 'rainbow-tags',
          -- tsx = 'rainbow-delimiters',
        },
        highlight = {
          'RainbowRed',
          'RainbowYellow',
          'RainbowBlue',
          'RainbowOrange',
          'RainbowGreen',
          'RainbowViolet',
          'RainbowCyan'
        },
      }
    end
  },
}

M.init = function()
  vim.g.skip_ts_context_commentstring_module = true

  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
      require('nvim-treesitter.parsers').typst = {
        install_info = {
          url = 'https://github.com/TheOnlyMrCat/tree-sitter-typst',
        },
      }
    end,
  })
end

M.config = function()
  require('nvim-treesitter').setup()
  require('nvim-treesitter').install(ensure_installed)

  vim.cmd [[ autocmd FileType typst setlocal commentstring=//\ %s ]]

  require('ts_context_commentstring').setup {
    enable = true,
    languages = {
      fish = "# %s",
      scheme = ";; %s",
      rpcgen = "/* %s */",
      typst = {
        __default = "// %s",
        comment = "// %s",
        string = "/* %s */",
        block = "/* %s */",
        line = "// %s",
        doc = "/// %s",
        doc_block = "/** %s */",
        doc_line = "/// %s",
      }
    }
  }

  local function start(buf)
    if vim.bo[buf].filetype ~= '' then
      pcall(vim.treesitter.start, buf)
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args) start(args.buf) end
  })

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then start(buf) end
  end

  -- Incremental selection
  Map('n', 'gn', function() vim.treesitter.select('parent') end)
  Map('x', 'gn', function() vim.treesitter.select('parent') end)
  Map('x', 'gr', function() vim.treesitter.select('child') end)
  Map('x', '.', function() vim.treesitter.select('parent') end)
  Map('x', ';', function() vim.treesitter.select('parent') end)

  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end

return M
