let g:NERDDefaultAlign = 'left'
let g:NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1


" Mappings

" Toggle NERDTree
nmap <silent> <leader>n :NERDTreeToggle<CR>

" Open NERDTree on buffer's file  
nmap <silent> <leader>dn :NERDTreeToggle %<CR>

" Open current location
" nmap <silent> <leader>cn :execute 'NERDTreeToggle' getcwd()<CR>

" h-l for parent-toggle
autocmd FileType nerdtree nmap <buffer> h p
autocmd FileType nerdtree nmap <buffer> l <CR>

" Exec in linux
autocmd FileType nerdtree nmap <buffer> f :call NERDTreeExecuteFileLinux()<CR> 
