" NERDTree integration
let g:nerdtreefileextensionhighlightfullname = 1
let g:nerdtreeexactmatchhighlightfullname = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 
let g:NERDTreeHighlightFoldersFullName = 1 

" Startify filetype icons 
let entry_format = "'   ['. index .']'. repeat(' ', (3 - strlen(index)))"
if exists('*WebDevIconsGetFileTypeSymbol')
  let entry_format .= 
        \ ". WebDevIconsGetFileTypeSymbol(entry_path) .' '.  entry_path"
else
  let entry_format .= '. entry_path'
endif
