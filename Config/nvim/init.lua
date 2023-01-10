require "opts"
require "plugins"
require "maps"

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--single-branch',
    'https://github.com/folke/lazy.nvim.git', lazypath
  })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('plugins', {
  concurrency = 16,
  install = { colorscheme = { 'dracula' } },
  -- checker = { enabled = true, concurrency = 4 },
  checker = { enabled = true },
  defaults = { lazy = true, version = "*" },
  performance = {
    cache = {
      enabled = true,
      path = vim.fn.stdpath("cache") .. "/lazy/cache",
      -- Once one of the following events triggers, caching will be disabled.
      -- To cache all modules, set this to `{}`, but that is not recommended.
      -- The default is to disable on:
      --  * VimEnter: not useful to cache anything else beyond startup
      --  * BufReadPre: this will be triggered early when opening a file from the command line directly
      disable_events = { "UIEnter", "BufReadPre" },
      ttl = 3600 * 24 * 5, -- keep unused modules for up to 5 days
      rtp = {
        disabled_plugins = {
          "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", "tohtml", "tutor",
          "zipPlugin"
        }
      }
    }
  }
})

Map('n', '<leader>L', ':Lazy<CR>')

