--! Template is borrowed from
--! https://github.com/binhtran432k/nvim/blob/main/lua/plugins/colorscheme.lua

local palette = {
  bg = "#282A36",
  fg = "#F8F8F2",
  selection = "#44475A",
  comment = "#6272A4",
  red = "#FF5555",
  orange = "#FFB86C",
  yellow = "#F1FA8C",
  green = "#50fa7b",
  purple = "#BD93F9",
  cyan = "#8BE9FD",
  pink = "#FF79C6",
  bright_red = "#FF6E6E",
  bright_green = "#69FF94",
  bright_yellow = "#FFFFA5",
  bright_blue = "#D6ACFF",
  bright_magenta = "#FF92DF",
  bright_cyan = "#A4FFFF",
  bright_white = "#FFFFFF",
  menu = "#21222C",
  visual = "#3E4452",
  gutter_fg = "#4B5263",
  nontext = "#3B4048",
  white = "#ABB2BF",
  black = "#191A21",
}

vim.api.nvim_create_autocmd("LspTokenUpdate", {
  callback = function(args)
    local token = args.data.token
    if token.type == "variable" and token.modifiers.static then
      vim.lsp.semantic_tokens.highlight_token(
        token, args.buf, args.data.client_id, "Ddystopia_static_var")
    end
  end,
})


local M2 = {
  "Mofiqul/dracula.nvim",
  commit = "9fe831e685a76e1a1898a694623b33247c4d036c",
  lazy = false,
  priority = 1000,
  opts = function()
    local dracula = require("dracula")
    local colors = dracula.colors()
    local groups = require("dracula.groups").setup(dracula.configs())
    local function get_group(key)
      local group = groups[key]
      if group then
        if group.link then
          return get_group(group.link)
        end
        return group
      end
      return nil
    end
    local overrides = {
      CoqtailChecked        = { bg = "#333444" },
      CoqtailSent           = { bg = "#3B4423" },
      CoqVernacCmd          = { link = "@function" },
      CoqKwd                = { link = "@keyword" },

      CursorLine            = { bg = "#21222C" },
      CursorLineNr          = { fg = "#F1FA8C", bg = "#21222C" },

      IndentLine            = { fg = "#44475a" },

      DiagnosticError       = { fg = "#db4b4b" },
      DiagnosticWarn        = { fg = "#e0af68" },
      DiagnosticInfo        = { fg = "#0db9d7" },
      DiagnosticHint        = { fg = "#10B981" },

      TSRainbowRed          = { fg = "#bf616a" }, -- termbg=#af5f5f
      TSRainbowYellow       = { fg = "#ffd700" }, -- termbg=#ffd700
      TSRainbowBlue         = { fg = "#88c0d0" }, -- termbg=#afd7ff
      TSRainbowOrange       = { fg = "#ebcb8b" }, -- termbg=#d7af87
      TSRainbowGreen        = { fg = "#a3de3c" }, -- termbg=#afff00
      TSRainbowViolet       = { fg = "#b48ead" }, -- termbg=#d7afdf
      TSRainbowCyan         = { fg = "#88c0d0" }, -- termbg=#afd7ff

      ["@lsp.mod.constant"] = { fg = colors.purple },
      Ddystopia_static_var   = { fg = colors.purple },

      ["@property"] = { },

      ["@lsp.type.macro"]                      = { link = "@function"},
      ["@field.lua"]                           = { link = "@property" },
      ["@tag.css"]                             = { fg = colors.pink },
      ["@attribute.css"]                       = { fg = colors.green },
      ["@property.css"]                        = { fg = colors.cyan, italic = true },
      ["@tag.scss"]                            = { fg = colors.pink },
      ["@attribute.scss"]                      = { fg = colors.green },
      ["@property.scss"]                       = { fg = colors.cyan, italic = true },
      ["@text.underline"]                      = { fg = colors.orange, underline = true },
      -- semantic
      ["@lsp.type.enum"]                       = { link = "@type" },
      ["@lsp.type.interface"]                  = { link = "@interface" },
      ["@lsp.type.keyword"]                    = { link = "@keyword" },
      ["@lsp.type.namespace"]                  = { link = "@namespace" },
      ["@lsp.type.parameter"]                  = { link = "@parameter" },
      ["@lsp.type.property"]                   = { link = "@property" },
      -- ["@lsp.type.variable"]                   = {}, -- use treesitter styles for regular variables
      ["@lsp.typemod.function.defaultLibrary"] = { link = "Special" },
      ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
      ["@lsp.type.annotation"]                 = { link = "@annotation" },
      -- ["@lsp.type.class"]                      = { fg = colors.cyan },
      -- ["@lsp.type.struct"]                     = { fg = colors.cyan },
      -- ["@lsp.type.enum"]                       = { fg = colors.cyan },
      -- ["@lsp.type.enumMember"]                 = { fg = colors.purple },
      -- ["@lsp.type.event"]                      = { fg = colors.cyan },
      -- ["@lsp.type.interface"]                  = { fg = colors.cyan },
      -- ["@lsp.type.modifier"]                   = { fg = colors.pink },
      -- ["@lsp.type.regexp"]                     = { fg = colors.yellow },
      -- ["@lsp.type.typeParameter"]              = { fg = colors.cyan },
      -- ["@lsp.type.decorator"]                  = { fg = colors.green },

      -- FoldColumn = { fg = colors.white },
      -- Visual = { fg = colors.black, bg = colors.white },
      -- GitSignsCurrentLineBlame                 = { link = "FoldColumn" },
      -- NvimTreeIndentMarker                     = { link = "FoldColumn" },
      -- LspCodeLens                              = { fg = colors.comment },
      -- MiniIndentscopeSymbol                    = { fg = colors.purple },
      -- Folded                                   = { bg = colors.purple },
      -- MoreMsg                                  = { fg = colors.bright_green },
      -- TreesitterContextLineNumber              = { fg = colors.purple, bg = colors.visual },
      -- TreesitterContext                        = { bg = colors.visual },

      --[[
      Constant                                 = { fg = colors.purple },
      Number                                   = { fg = colors.purple },
      Boolean                                  = { fg = colors.purple },
      Float                                    = { fg = colors.green },
      Operator                                 = { fg = colors.pink },
      Identifier                               = { fg = colors.fg },
      Function                                 = { fg = colors.green },
      Include                                  = { fg = colors.pink },
      Structure                                = { fg = colors.purple },
      Underlined                               = { fg = colors.orange, underline = true },

      DiagnosticUnnecessary                    = { undercurl = true, sp = colors.comment },
    ]]

    }
    return {
      -- italic_comment = true,
      overrides = overrides,
    }
  end,
  config = function(_, opts)
    local dracula = require("dracula")
    dracula.setup(opts)
    dracula.load()
  end,
}

return M2
