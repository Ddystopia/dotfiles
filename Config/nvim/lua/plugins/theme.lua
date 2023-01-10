local M = { -- theme
  -- 'dracula/vim',
  'Mofiqul/dracula.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- `runtime ...` is to solve bug with multiple `:colorscheme dracula`
    Cmd [[ 
      colorscheme dracula

      hi! CursorLine guibg=#21222C
      hi! CursorLineNr guifg=#F1FA8C guibg=#21222C gui=none

      hi IndentLine guifg=#44475a

      hi DiagnosticError ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#db4b4b
      hi DiagnosticWarn  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#e0af68
      hi DiagnosticInfo  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#0db9d7
      hi DiagnosticHint  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#10B981

      runtime after/plugin/dracula.vim
      ]]
  end

  --[[
      hi DiagnosticError ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#F24B42
      hi DiagnosticWarn  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#F5B439
      hi DiagnosticInfo  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#AEFA47
      hi DiagnosticHint  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#14BC85

      highlight! CmpItemAbbrMatch       guibg=NONE guifg=#569CD6
      highlight! CmpItemAbbrMatchFuzzy  guibg=NONE guifg=#569CD6
      highlight! CmpItemKindFunction    guibg=NONE guifg=#C586C0
      highlight! CmpItemKindMethod      guibg=NONE guifg=#C586C0
      highlight! CmpItemKindVariable    guibg=NONE guifg=#9CDCFE
      highlight! CmpItemKindKeyword     guibg=NONE guifg=#D4D4D4
    --]]
}

return M

--[[

hi! Cursor none

hi Normal guibg=NONE
hi NormalBg guibg=#282A36

hi! CursorLine guibg=#21222C
hi! CursorLineNr guifg=#F1FA8C guibg=#21222C gui=none

hi IndentLine guifg=#44475a

hi DiagnosticError ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#db4b4b
hi DiagnosticWarn  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#e0af68
hi DiagnosticInfo  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#0db9d7
hi DiagnosticHint  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#10B981


hi DraculaErrorLine guifg=NONE guibg=NONE
hi DraculaWarnLine guifg=NONE guibg=NONE
hi DraculaInfoLine guifg=NONE guibg=NONE

hi DraculaWinSeparator guibg=#282A36
hi NvimSeparator guifg=#ff79c6

hi! link @text.strong DraculaOrangeBold
hi! @text.strike gui=strikethrough
hi! link @text.emphasis DraculaYellowItalic
hi! link @text.title DraculaPurpleBold
hi! link @text.literal DraculaYellow
hi! link @text.reference DraculaPurple
hi! link @text.uri DraculaCyan

" Semantic tokens

hi link LspNamespace @namespace
hi link LspType @type
hi link LspClass Class
" hi link LspEnum LspCxxHlGroupEnumConstant
" hi link LspInterface
" hi link LspStruct
" hi link LspTypeParameter DraculaOrangeItalic
" hi link LspParameter DraculaOrange
" hi link LspVariable
hi LspProperty guifg=#e8d7ff
hi link LspEnumMember DraculaPurple
" hi link LspEvent
hi link LspFunction Function
hi link LspMethod Function
" hi link LspMacro
" hi link LspKeyword
" hi link LspModifier
" hi link LspComment
" hi link LspString
" hi link LspNumber
" hi link LspRegexp
" hi link LspOperator
" hi LspMember guifg=#f092dd
"
" hi LspDeclaration gui=bold
" hi LspDefinition gui=bold
hi link LspReadonly DraculaPurple
" hi link LspStatic
hi LspDeprecated gui=strikethrough
" hi link LspAbstract
hi LspAsync gui=italic
" hi link LspModification
" hi link LspDocumentation DraculaOrange
hi LspDefaultLibrary guifg=#ff9999

hi link @member @function
hi link @method @function
hi link @interface @type
hi @property guifg=#e8d7ff
hi link @enumMember DraculaPurple

hi link @readonly DraculaPurple
" hi @readonly gui=bold
hi @deprecated gui=strikethrough
hi @async gui=underdotted
" hi @defaultLibrary guifg=#ff9999
hi @defaultLibrary gui=italic
" hi @declaration gui=underdotted


" runtime after/plugin/dracula.vim

--]]
