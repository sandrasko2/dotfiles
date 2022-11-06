set paste

set formatoptions=

set number

set ruler

set statusline+=%F\ %l\:%c

set ignorecase

set nohlsearch

syntax off

highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9

match OverLength /\%120v.\+/

set t_ti= t_te=

set tabstop=4 shiftwidth=4 expandtab

:retab
