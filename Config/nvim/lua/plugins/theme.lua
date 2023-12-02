--! Template is borrowed from
--! https://github.com/binhtran432k/nvim/blob/main/lua/plugins/colorscheme.lua

---@class Color
---@field r number
---@field g number
---@field b number

---@param color Color
---@return string
local function rgb_to_hex(color)
  return string.format("#%02X%02X%02X", color.r, color.g, color.b)
end

---@param hex string
---@return Color
local function hex_to_rgb(hex)
  local r = tonumber("0x" .. hex:sub(2, 3))
  local g = tonumber("0x" .. hex:sub(4, 5))
  local b = tonumber("0x" .. hex:sub(6, 7))
  return { r = r, g = g, b = b }
end

---@param hex1 string
---@param hex2 string
---@param max number
---@return string[]
local function get_gradients(hex1, hex2, max)
  local premax = max - 1

  ---@param h1 number
  ---@param h2 number
  ---@param i number
  ---@return integer
  local function mix_hex(h1, h2, i)
    return math.floor((h1 * (premax - i) + h2 * i) / premax)
  end

  ---@param color1 Color
  ---@param color2 Color
  ---@param i number
  ---@return Color
  local function mix(color1, color2, i)
    return {
      r = mix_hex(color1.r, color2.r, i),
      g = mix_hex(color1.g, color2.g, i),
      b = mix_hex(color1.b, color2.b, i),
    }
  end

  local color1 = hex_to_rgb(hex1)
  local color2 = hex_to_rgb(hex2)
  local gradients = {}

  local i = 0
  while i < max do
    gradients[#gradients + 1] = rgb_to_hex(mix(color1, color2, i))
    i = i + 1
  end

  return gradients
end

local M2 = {
  "Mofiqul/dracula.nvim",
  lazy = false,
  priority = 1000,
  opts = function()
    local dracula = require("dracula")
    local colors = dracula.colors()
    -- local dark_colors = {
    --   red = "#773333",
    --   orange = "#996E40",
    --   yellow = "#909654",
    --   green = "#309649",
    --   purple = "#604784",
    --   cyan = "#538B97",
    --   pink = "#894766",
    -- }
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
      -- My
      CursorLine      = { bg = "#21222C" },
      CursorLineNr    = { fg = "#F1FA8C", bg = "#21222C" },

      IndentLine      = { fg = "#44475a" },

      DiagnosticError = { fg = "#db4b4b" },
      DiagnosticWarn  = { fg = "#e0af68" },
      DiagnosticInfo  = { fg = "#0db9d7" },
      DiagnosticHint  = { fg = "#10B981" },

      TSRainbowRed    = { fg = "#bf616a" }, -- termbg=#af5f5f
      TSRainbowYellow = { fg = "#ffd700" }, -- termbg=#ffd700
      TSRainbowBlue   = { fg = "#88c0d0" }, -- termbg=#afd7ff
      TSRainbowOrange = { fg = "#ebcb8b" }, -- termbg=#d7af87
      TSRainbowGreen  = { fg = "#a3de3c" }, -- termbg=#afff00
      TSRainbowViolet = { fg = "#b48ead" }, -- termbg=#d7afdf
      TSRainbowCyan   = { fg = "#88c0d0" }, -- termbg=#afd7ff

      ["@lsp.mod.constant"] = { fg = "#b37ff5" },
      ["@lsp.mod.static"] = { fg = "#b37ff5" },


      -- From that guy

      --[[
      FoldColumn = { fg = colors.white },
      Visual = { fg = colors.black, bg = colors.white },
      GitSignsCurrentLineBlame                 = { link = "FoldColumn" },
      NvimTreeIndentMarker                     = { link = "FoldColumn" },
      LspCodeLens                              = { fg = colors.comment },
      MiniIndentscopeSymbol                    = { fg = colors.purple },
      Folded                                   = { bg = dark_colors.purple },
      MoreMsg                                  = { fg = colors.bright_green },
      TreesitterContextLineNumber              = { fg = colors.purple, bg = colors.visual },
      TreesitterContext                        = { bg = colors.visual },

      ["@field.lua"]                           = { link = "@property" },
      ["@tag.css"]                             = { fg = colors.pink },
      ["@attribute.css"]                       = { fg = colors.green },
      ["@property.css"]                        = { fg = colors.cyan, italic = true },
      ["@tag.scss"]                            = { fg = colors.pink },
      ["@attribute.scss"]                      = { fg = colors.green },
      ["@property.scss"]                       = { fg = colors.cyan, italic = true },
      ["@text.underline"]                      = { fg = colors.orange, underline = true },
      -- semantic
      -- ["@lsp.type.enum"] = { link = "@type" },
      -- ["@lsp.type.interface"] = { link = "@interface" },
      ["@lsp.type.keyword"]                    = { link = "@keyword" },
      ["@lsp.type.namespace"]                  = { link = "@namespace" },
      ["@lsp.type.parameter"]                  = { link = "@parameter" },
      ["@lsp.type.property"]                   = { link = "@property" },
      ["@lsp.type.variable"]                   = {}, -- use treesitter styles for regular variables
      ["@lsp.typemod.function.defaultLibrary"] = { link = "Special" },
      ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
      ["@lsp.type.annotation"]                 = { link = "@annotation" },
      ["@lsp.type.class"]                      = { fg = colors.cyan },
      ["@lsp.type.struct"]                     = { fg = colors.cyan },
      ["@lsp.type.enum"]                       = { fg = colors.cyan },
      ["@lsp.type.enumMember"]                 = { fg = colors.purple },
      ["@lsp.type.event"]                      = { fg = colors.cyan },
      ["@lsp.type.interface"]                  = { fg = colors.cyan },
      ["@lsp.type.modifier"]                   = { fg = colors.pink },
      ["@lsp.type.regexp"]                     = { fg = colors.yellow },
      ["@lsp.type.typeParameter"]              = { fg = colors.cyan },
      ["@lsp.type.decorator"]                  = { fg = colors.green },

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
    local transparent = {
      -- "Normal",
      -- "NormalFloat",
      -- "MoreMsg",
      -- "SignColumn",
      -- "NvimTreeNormal",
      -- "NeoTreeNormal",
      -- "Pmenu",
      -- "BufferLineFill",
      -- "CmpItemAbbrDeprecated",
      -- "CmpItemAbbrMatch",
    }
    local cursive = {
      -- "@keyword",
      -- "@keyword.operator",
      -- "@keyword.function",
      -- "@repeat",
      -- "@conditional",
      -- "@include",
      -- "@function.builtin",
      -- "@tag.attribute",
      -- "Keyword",
      -- "Keywords",
      -- "Repeat",
      -- "Conditional",
      -- "Include",
    }
    local logo_colors = get_gradients(colors.purple, colors.pink, 8)
    for _, key in ipairs(transparent) do
      local highlight = get_group(key)
      if highlight then
        highlight.bg = colors.bg
        overrides[key] = highlight
      end
    end
    for _, key in ipairs(cursive) do
      local highlight = get_group(key)
      if highlight then
        highlight.italic = true
        overrides[key] = highlight
      end
    end
    for i, key in ipairs(logo_colors) do
      overrides["StartLogo" .. i] = { fg = key }
    end
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
