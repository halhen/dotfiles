" Leader functions
let mapleader = ","
" Create an underscore of ='s at the current line
noremap <leader>1 yypVr=

" Key remapping
noremap ' `
noremap ` '
" Move up and down lines by screen
noremap j gj
noremap k gk
" Stop mis-hitting F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Misc set:s
set nocompatible
set title
set backspace=indent,eol,start
set showmatch
syntax enable
set mouse=a

" More history and undolevels
set history=1024
set undolevels=1024

set cryptmethod=blowfish

" Color scheme
colorscheme dante
hi Folded ctermbg=Black

" Tab settings
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Folds
set foldmethod=marker
nmap <enter> za

" Tabbing
noremap <left> :tabp<CR>
noremap <right> :tabn<CR>
" Disable arrow keys to really get off them
noremap <up> <NOP>
noremap <down> <NOP>
inoremap <left> <C-o>:tabp<CR>
inoremap <right> <C-o>:tabn<CR>
inoremap <up> <NOP>
inoremap <down> <NOP>

" Space for scrolling
noremap <space> <C-d>

" Search
set incsearch
set ignorecase
set smartcase
set gdefault

" Wildmenu
set wildmenu
set wildmode=list:longest

" Backup
set backup
set backupdir=/tmp/

" Smarter python indentation
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" gf opens file under cursor in new tab, creating it if nescessary
map gf :tabe <cfile><CR>
