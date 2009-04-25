" Tab settings
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Flash matching paranthesis
set showmatch

" Search as you type
set incsearch

" Backup
set backup
set backupdir=/tmp/

" File tabs
map <F1> :tabp<CR>
map <F2> :tabn<CR>

" Enable syntax highlighting
syntax enable

" More history and undolevels
set history=1024
set undolevels=1024

" Highlight word under cursor
highlight flicker cterm=bold ctermfg=white
au CursorMoved <buffer> exe 'match flicker /\V\<'.escape(expand('<cword>'), '/').'\>/'

