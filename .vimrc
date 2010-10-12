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
set encoding=utf-8
set title
set cursorline
set relativenumber
set backspace=indent,eol,start
set showmatch
syntax enable
set mouse=a

" More history and undolevels
set history=1024
set undolevels=1024
set undofile
set undodir=~/.undo

" Color scheme
colorscheme dante

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

" Search
noremap <space> /\v
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
