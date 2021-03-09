let mapleader = " "
let g:mapleader = " "

function CloseBuffer()
  if @% == "" && len(getbufinfo({'buflisted':1})) < 2
    :q
  endif

  if !&readonly 
    :w
  endif

  :bdelete
endfunction

function FormatFile()
  if index(['javascript', 'typescript', "css", "html", "vue","javascriptreact", "markdown", "yaml"], &ft) != -1
    :CocCommand prettier.formatFile
  elseif &ft == "rust"
    :RustFmt
  elseif &ft == "c" || &ft == "cpp"
    :ClangFormat
  else 
    normal gg=G``
  endif
endfunction

" reload config
nmap <leader>vr :call LoadConfig_CONFIG()<CR>

" format file
nmap <leader>f :call FormatFile()<CR>

" go to definition in new tab
nmap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" copy to global buffer
vmap <silent> <leader>y "+y

" Switch spell check
nmap <silent> <leader>ps :set spell!<CR>

" Close buffer
nmap <silent> <leader>w :call CloseBuffer()<CR>

" Remove search
nmap <silent> <leader>, :noh<cr>

" Toggle visualize tabs and EOL
nmap <leader>pl :set list!<CR>
