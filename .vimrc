" Leader functions
let mapleader = ","
" Create an underscore of separators as per asciidoc defaults
noremap <leader>0 yyp^v$r=
noremap <leader>1 yyp^v$r-
noremap <leader>2 yyp^v$r~
noremap <leader>3 yyp^v$r^
noremap <leader>4 yyp^v$r+
" Clean up whitespace
noremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" Initiate replace with word under cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>/
" Replace word under cursor with the yanked text
nnoremap <leader>S "_diwP
" Word count
noremap <leader>wc :w !wc<CR>
inoremap <leader>wc <C-o>:w !wc<CR>

" gf opens file under cursor in new tab, creating it if nescessary
map gf :tabe <cfile><CR>
" go opens file under cursor using xdg-open; also works with URLs
map go :silent !xdg-open "<cWORD>"<CR>:redraw!<CR>

" :w!! to write file as root
" (Not a perfect solution as it asks to reload the file, but it works)
cmap w!! %!sudo tee >/dev/null %

" Key remapping
noremap ' `
noremap ` '
" Move up and down lines by screen
noremap j gj
noremap k gk

" H and L to beginning and end of line
noremap H ^
noremap L g_

" Tabbing
noremap <left> :tabp<CR>
noremap <right> :tabn<CR>
inoremap <left> <C-o>:tabp<CR>
inoremap <right> <C-o>:tabn<CR>

" Disable arrow keys
noremap <up> <NOP>
noremap <down> <NOP>
inoremap <up> <NOP>
inoremap <down> <NOP>

" Space for jumping down
noremap <space> <C-d>

" Center on found element
map * *zz
map # #zz
map N Nzz
map n nzz

" Misc set:s
set nocompatible
set title
set backspace=indent,eol,start
set showmatch
set autochdir
syntax enable
set mouse=a

set hlsearch
" Clear search highlight
noremap Q :let @/ = ""<CR>

set showmode
set showcmd
set ruler

" Line wrap
set wrap
set linebreak
set nolist

" More history and undolevels
set history=1024
set undolevels=1024

set cryptmethod=blowfish

" Color scheme
" colorscheme dante
" hi Folded ctermbg=Black

" Tab settings
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Folds
set foldmethod=marker
nmap <enter> za

" Search
set incsearch
set ignorecase
set smartcase
set gdefault

" Wildmenu
set wildmenu
set wildmode=list:longest

" Backup and swp directory
if !filewritable("/tmp/.vim")
    silent execute '!umask 000; mkdir /tmp/.vim'
endif
set backup
set backupdir=/tmp/.vim
set directory=/tmp/.vim

" Wrap text
au FileType mail,asciidoc,gitcommit setlocal textwidth=72 formatoptions=tcql
" Reformat whole mail
au FileType mail,asciidoc,gitcommit nmap <F1> gggqGgg
" Reformat paragraph under cursor
au FileType mail,asciidoc,gitcommit nmap <F2> gqap


" Smarter python indentation
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
" Execute python script with F5
au FileType python map <F5> :w !/usr/bin/python2<CR>
" Insert debug point with F7
au FileType python map <F7> Oimport pdb; pdb.set_trace();<ESC>

" Auto hightlight word under cursor
au FileType bash,sh,zsh,python,javascript,html autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

autocmd FileType c setlocal cindent
