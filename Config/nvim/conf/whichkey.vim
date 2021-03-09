" FULL COPYPASTE FROM GITHUB
" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <leader>? :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader>? :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>


" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" set timeoutlen=100

" Ignored mappings
let g:which_key_map.1 = 'which_key_ignore'
let g:which_key_map.2 = 'which_key_ignore'
let g:which_key_map.3 = 'which_key_ignore'
let g:which_key_map.4 = 'which_key_ignore'
let g:which_key_map.5 = 'which_key_ignore'
let g:which_key_map.6 = 'which_key_ignore'
let g:which_key_map.7 = 'which_key_ignore'
let g:which_key_map.8 = 'which_key_ignore'
let g:which_key_map.9 = 'which_key_ignore'

" Single mappings
let g:which_key_map['n'] = [ 'NERDTreeToggle', 'NERDTree' ]
let g:which_key_map[','] = [ 'noh', 'Clear highlighting' ]
" let g:which_key_map['TAB'] = [ 'bn', 'Cycle buffers' ]       " Dublicate :(
let g:which_key_map[';'] = [ ':Vista', 'open tags by vista' ]
let g:which_key_map['NUM'] = 'jump to NUM tab'

" Group mappings

" d - directory (working w/ current file as well)
let g:which_key_map.d = {
      \ 'name' : '+directory' ,
      \ 'w' : 'write to the buffer' ,
      \ 'c' : 'set current dir as working' ,
      \ 'n' : 'open NERDTree in current buffer' ,
      \ }

" SPC - easymotion
let g:which_key_map[' '] = {
      \ 'name' : '+easymotion' ,
      \ 'h' : 'goto inline backward' ,
      \ 'j' : 'goto line down' ,
      \ 'k' : 'goto line up' ,
      \ 'l' : 'goto inline forward' ,
      \ 'n' : 'next item (ezm search)' ,
      \ 'N' : 'previous item (ezm search)' ,
      \ }

" v - vim and stuff
let g:which_key_map.v = {
      \ 'name' : '+vim' ,
      \ 'e' : 'edit myvimrc' ,
      \ 's' : 'source myvimrc' ,
      \ }

" c - CoC
let g:which_key_map.c = {
      \ 'name' : '+coc' ,
      \ 'c' : 'restart' ,
      \ 'a' : {
            \ 'name' : '+action' ,
            \ 'a' : 'for whole buffer' ,
            \ 's' : 'for selected' ,
            \ } ,
      \ 'q' : 'auto fix current line' ,
      \ 'r' : 'rename' ,
      \ 'n' : 'next error' ,
      \ 'N' : 'prev error' ,
      \ 'g' : {
            \ 'name' : '+coc go' ,
            \ 'd' : 'definition' ,
            \ 'i' : 'implementation' ,
            \ 'y' : 'type definition' ,
            \ 'r' : 'references' ,
            \ } ,
      \ }

" f - fuzzy f
let g:which_key_map.f = {
      \ 'name' : '+fuzzy' ,
      \ 'f' : 'fzf w/ preview' ,
      \ 'r' : 'Rg (content srch)' ,
      \ 'm' : 'marks' ,
      \ 'b' : 'buffers' ,
      \ 't' : 'tags by vista' ,
      \ 'g' : 'git grep' ,
      \ }

" p - appearance (orig. - Pencil)
let g:which_key_map.p = {
      \ 'name' : '+appearance' ,
      \ 'p' : 'pencil' ,
      \ 'g' : 'goyo' ,
      \ 'l' : 'list (tab/endl display)' ,
      \ 's' : 'spell check' ,
      \ 'h' : 'limelight (highlight current paragraph)' ,
      \ 'c' : 'conceal'
      \ }

" s - start something
let g:which_key_map.s = {
      \ 'name' : '+start' ,
      \ 's' : 'startify' ,
      \ }

" l - CocLists
let g:which_key_map.l = {
      \ 'name' : '+coclist' ,
      \ 'l' : 'custom' ,
      \ 'y' : 'yanks' ,
      \ 'f' : 'floaterms' ,
      \ 'c' : 'coc cmds' ,
      \ 'a' : 'coc actions' ,
      \ 'b' : 'buffers' ,
      \ ';' : 'resume previous' ,
      \ 'd' : 'diagnostic' ,
      \ }

" g - git (fugitive as well)
let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'g' : 'git' ,
      \ 'a' : 'add %' ,
      \ 'A' : 'add .' ,
      \ 'c' : 'commit' ,
      \ 'p' : 'pull' ,
      \ 'P' : 'push' ,
      \ 'd' : 'diff' ,
      \ 'f' : 'diffget from left' ,
      \ 'h' : 'diffget from right' ,
      \ 's' : 'status' ,
      \ 'l' : 'log' ,
      \ 'r' : 'remove' ,
      \ 'b' : 'blame' ,
      \ 'B' : 'browse' ,
      \ 'v' : 'view commits' ,
      \ 'V' : 'view commits for current buffer' ,
      \ 'm' : 'commit message' ,
      \ }

" r - render (prewiev and stuff)
let g:which_key_map.r = {
      \ 'name' : '+render' ,
      \ 'm' : 'md prewiew' ,
      \ 'M' : 'stop md preview' ,
      \ 'w' : 'web live server (Bracey)' ,
      \ 'W' : 'stop web life server' ,
      \ }

" S - Session
let g:which_key_map.S = {
      \ 'name' : '+Session' ,
      \ 'q' : 'quit' ,
      \ 'd' : 'delete' ,
      \ 'l' : 'load' ,
      \ 'S' : 'save' ,
      \ }

" i - imports (js)
let g:which_key_map.i = {
      \ 'name' : '+import' ,
      \ 'f' : 'file' ,
      \ 'F' : 'file list' ,
      \ 'c' : 'fix' ,
      \ 's' : 'sort' ,
      \ 'p' : 'prompt' ,
      \ 'u' : 'usage' ,
      \ 'g' : 'def' ,
      \ 'G' : 'def list' ,
      \ }


" Register which key map
call which_key#register('<Space>', "g:which_key_map")



" Not My Property But It Looks Good For Me (NMPBILGFM)
" " g is for git
" let g:which_key_map.g = {
"      \ 'name' : '+git' ,
"      \ 'a' : [':Git add .'                        , 'add all'],
"      \ 'A' : [':Git add %'                        , 'add current'],
"      \ 'b' : [':Git blame'                        , 'blame'],
"      \ 'B' : [':GBrowse'                          , 'browse'],
"      \ 'c' : [':Git commit'                       , 'commit'],
"      \ 'd' : [':Git diff'                         , 'diff'],
"      \ 'D' : [':Gdiffsplit'                       , 'diff split'],
"      \ 'g' : [':GGrep'                            , 'git grep'],
"      \ 'G' : [':Gstatus'                          , 'status'],
"      \ 'h' : [':GitGutterLineHighlightsToggle'    , 'highlight hunks'],
"      \ 'H' : ['<Plug>(GitGutterPreviewHunk)'      , 'preview hunk'],
"      \ 'i' : [':Gist -b'                          , 'post gist'],
"      \ 'j' : ['<Plug>(GitGutterNextHunk)'         , 'next hunk'],
"      \ 'k' : ['<Plug>(GitGutterPrevHunk)'         , 'prev hunk'],
"      \ 'l' : [':Git log'                          , 'log'],
"      \ 'm' : ['<Plug>(git-messenger)'             , 'message'],
"      \ 'p' : [':Git push'                         , 'push'],
"      \ 'P' : [':Git pull'                         , 'pull'],
"      \ 'r' : [':GRemove'                          , 'remove'],
"      \ 's' : ['<Plug>(GitGutterStageHunk)'        , 'stage hunk'],
"      \ 'S' : [':!git status'                      , 'status'],
"      \ 't' : [':GitGutterSignsToggle'             , 'toggle signs'],
"      \ 'u' : ['<Plug>(GitGutterUndoHunk)'         , 'undo hunk'],
"      \ 'v' : [':GV'                               , 'view commits'],
"      \ 'V' : [':GV!'                              , 'view buffer commits'],
"      \ }'
