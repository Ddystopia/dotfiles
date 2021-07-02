function GotoWindow(id) 
  call win_gotoid(a:id)
endfunction

let g:vimspector_enable_mappings = 'HUMAN'

nmap <leader>dt :call vimspector#Launch()<CR>
nmap <leader>dd :call vimspector#Launch()<CR><space>dv<CR>:q<CR>
nmap <leader>de :call vimspector#Reset()<CR>
nmap <leader>da <Plug>VimspectorWatch
nmap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nmap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nmap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nmap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nmap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOneOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nmap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>dr <Plug>VimspectorRunToCursore
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>dp <Plug>VimspectorToggleConditionalBreakpoint
 
" autocmd FileType cpp nmap <leader>dd :CocCommand cpp.debug.vimspector.start<CR>
