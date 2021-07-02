let g:coc_global_extensions = [
      \ 'coc-snippets',
      \ 'coc-actions',
      \ 'coc-sh',
      \ 'coc-lists',
      \ 'coc-pairs',
      \ 'coc-emoji',
      \ 'coc-floaterm',
      \ 'coc-yaml',
      \ 'coc-prettier',
      \ 'coc-vimlsp',
      \ 'coc-yank',
      \ 'coc-json',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-python',
      \ 'coc-marketplace',
      \ 'coc-emmet',
      \ 'coc-highlight',
      \ 'coc-diagnostic',
      \ 'coc-eslint',
      \ 'coc-fzf-preview',
      \ 'coc-markdownlint',
      \ 'coc-stylelint',
      \ 'coc-stylelintplus',
      \ 'coc-texlab',
      \ 'coc-rls'
      \ ]

set nobackup
set nowritebackup
set updatetime=400
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <C-Space> to trigger completion.
inoremap <silent><expr> <C-Space> coc#refresh()
"
if exists('*complete_info')
  inoremap <expr> <cr> 
        \ complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Show doc func
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
" autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json 
        \ setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Mapping

" Diagnostic navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> <leader>cgd <Plug>(coc-definition)
nmap <silent> <leader>cgy <Plug>(coc-type-definition)
nmap <silent> <leader>cgi <Plug>(coc-implementation)
nmap <silent> <leader>cgr <Plug>(coc-references)

" Show documentation for word under cursor
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Symbol renaming
nmap <leader>cr <Plug>(coc-rename)

" Formatting selected code
 xmap <leader>cf  <Plug>(coc-format-selected)
 nmap <leader>cf  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>cas  <Plug>(coc-codeaction-selected)
nmap <leader>cas  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>caa  <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>cq  <Plug>(coc-fix-current)

" Run Prettier
nmap <leader>cp :CocCommand prettier.formatFile<CR>

" Restart CoC
nmap <leader>cc :CocRestart<CR>

" Errors
nmap <leader>cn <Plug>(coc-diagnostic-next-error)
nmap <leader>cN <Plug>(coc-diagnostic-prev-error)


" CocLists
nmap <leader>ll :CocList 
nmap <leader>l; :CocListResume<CR>
nmap <leader>ly :CocList yank<CR>
nmap <leader>lf :CocList floaterm<CR>
nmap <leader>lc :CocList commands<CR>
nmap <leader>la :CocList actions<CR>
nmap <leader>lb :CocList buffers<CR>
nmap <leader>ld :CocList diagnostic<CR>
