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

vim.cmd [[
  syn region    rustString      matchgroup=rustStringDelimiter start=+c"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeError,rustStringContinuation
  syn region    rustString      matchgroup=rustStringDelimiter start='c\?r\z(#*\)"' end='"\z1' contains=@Spell
  syn keyword   @keyword.operator    as
  syn keyword   @keyword.function    fn
]]

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
      CoqtailChecked  = { bg = "#333444" },
      CoqtailSent     = { bg = "#3B4423" },
      CoqVernacCmd    = { link = "@function" },
      CoqKwd          = { link = "@keyword" },

      CursorLine      = { bg = "#21222C" },
      CursorLineNr    = { fg = "#F1FA8C", bg = "#21222C" },

      IndentLine      = { fg = "#44475a" },

      UndotreeTimeStamp = { fg = colors.yellow },

      DiagnosticError = { fg = "#db4b4b" },
      DiagnosticWarn  = { fg = "#e0af68" },
      DiagnosticInfo  = { fg = "#0db9d7" },
      DiagnosticHint  = { fg = "#10B981" },

      RainbowRed    = { fg = "#bf616a" }, -- termbg=#af5f5f
      RainbowYellow = { fg = "#ffd700" }, -- termbg=#ffd700
      RainbowBlue   = { fg = "#88c0d0" }, -- termbg=#afd7ff
      RainbowOrange = { fg = "#ebcb8b" }, -- termbg=#d7af87
      RainbowGreen  = { fg = "#a3de3c" }, -- termbg=#afff00
      RainbowViolet = { fg = "#b48ead" }, -- termbg=#d7afdf
      RainbowCyan   = { fg = "#8fbcbb" }, -- termbg=#87d7d7

      ["Boolean"]        = { link = "@boolean" },
      ["Character"]      = { link = "@character" },
      ["Conditional"]    = { link = "@conditional" },
      ["Constant"]       = { link = "@constant" },
      ["Error"]          = { link = "@error" },
      ["Exception"]      = { link = "@exception" },
      ["Float"]          = { link = "@float" },
      ["Function"]       = { link = "@function" },
      ["Identifier"]     = { link = "@identifier" },
      ["Keyword"]        = { link = "@keyword" },
      ["Label"]          = { link = "@label" },
      ["Number"]         = { link = "@number" },
      ["Operator"]       = { link = "@operator" },
      ["String"]         = { link = "@string" },
      ["Type"]           = { link = "@type" },


      ["@storageclass"]                    = { link = "@keyword" },
      Ddystopia_static_var                 = { fg = colors.purple },
      ["@property"]                        = { link = "@parameter" },

      ["rustLifetime"]                     = { link = "@keyword" },
      ["rustAttributeParenthesizedParens"] = { link = "@punctuation.bracket.rust" },
      ["rustDecNumber"]                    = { link = "@number.rust" },
      ["rustAttribute"]                    = { link = "@punctuation.special.rust" },
      ["rustArrowCharacter"]               = { fg = colors.fg },
      ["rustSelf"]                         = { link = "@variable.builtin" },
      ["rustModPath"]                      = { link = "@namespace" },
      ["rustEnumVariant"]                  = { link = "@enumMember" },
      ["rustQuestionMark"]                 = { link = "@operator" },


      ["@lsp.mod.constant"]                            = { fg = colors.purple },
      ["@lsp.type.macro"]                              = { link = "@function" },
      ["@lsp.type.static.rust"]                        = { link = "@constant" },
      ["@lsp.type.typeAlias.rust"]                     = { link = "@type" },
      ["@lsp.type.lifetime.rust"]                      = { link = "@keyword" },
      ["@lsp.typemod.keyword.constant.rust"]           = { link = "@keyword" },
      ["@lsp.typemod.function.static.rust"]            = { link = "@constant" },
      ["@lsp.type.union.rust"]                         = { link = "@type" },
      ["@lsp.type.derive.rust"]                        = { link = "@type" },
      ["@lsp.type.buildinType.rust"]                   = { link = "@type.builtin" },
      ["@lsp.type.string.rust"]                        = { link = "no" }, -- I don't wat lsp to hightlight stirngs
      ["@lsp.typemod.string.attribute.rust"]           = { link = "@lsp.type.string.rust" },
      ["@lsp.typemod.generic.attribute.rust"]          = { fg = colors.fg },
      ["@lsp.typemod.builtinAttribute.attribute.rust"] = { fg = colors.green },
      ["@lsp.typemod.punctuation.injected.rust"]       = { fg = colors.fg },


      ["@field.lua"]                           = { link = "@property" },
      ["@tag.css"]                             = { fg = colors.pink },
      ["@attribute.css"]                       = { fg = colors.green },
      ["@property.css"]                        = { fg = colors.cyan, italic = true },
      ["@tag.scss"]                            = { fg = colors.pink },
      ["@attribute.scss"]                      = { fg = colors.green },
      ["@property.scss"]                       = { fg = colors.cyan, italic = true },
      ["@text.underline"]                      = { fg = colors.orange, underline = true },
      ["@module"]                              = { link = "@namespace" },

      ["@lsp.type.enum"]                       = { link = "@type" },
      ["@lsp.type.interface"]                  = { link = "@interface" },
      ["@lsp.type.keyword"]                    = { link = "@keyword" },
      ["@lsp.type.namespace"]                  = { link = "@namespace" },
      ["@lsp.type.parameter"]                  = { link = "@parameter" },
      ["@lsp.type.property"]                   = { link = "@property" },
      ["@lsp.typemod.function.defaultLibrary"] = { link = "Special" },
      ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
      ["@lsp.type.annotation"]                 = { link = "@annotation" },
      ["@lsp.type.unresolvedReference.rust"]   = { underline = true }

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
