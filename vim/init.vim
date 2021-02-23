:au FocusLost * :wa
set nocompatible
set encoding=utf-8
set autowrite
set autoread

nmap ; :
set guifont=Lucida_Console:h12:cANSI:qDRAFT

nmap ` <C-w>w
syntax on

set backspace=indent,eol,start
set hlsearch
set ignorecase
set smartcase
set incsearch
set ruler

:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

:colorscheme desert

" j and k are display-line based
nmap k gk
nmap <Up> gk
nmap j gj
nmap <Down> gj

" use system keyboard
set clipboard=unnamed