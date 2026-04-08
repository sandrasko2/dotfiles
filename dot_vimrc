" ~/.vimrc — IDE-lite configuration with vim-plug

" ---------------------------------------------------------------------------
" vim-plug — auto-install on first run
" ---------------------------------------------------------------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ---------------------------------------------------------------------------
" Plugins
" ---------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'              " File explorer sidebar
Plug 'vim-airline/vim-airline'         " Status line
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'               " Fuzzy finder
Plug 'airblade/vim-gitgutter'         " Git diff in gutter
Plug 'tpope/vim-surround'             " Change surrounding chars
Plug 'jiangmiao/auto-pairs'           " Auto-close brackets
Plug 'tpope/vim-commentary'           " Toggle comments (gcc)
Plug 'tpope/vim-fugitive'             " Git commands in vim
Plug 'tpope/vim-sensible'             " Sensible defaults
Plug 'pearofducks/ansible-vim'        " Ansible/YAML highlighting
Plug 'morhetz/gruvbox'                " Color scheme

call plug#end()

" ---------------------------------------------------------------------------
" General settings
" ---------------------------------------------------------------------------
set number                   " Line numbers
set relativenumber           " Relative line numbers
set ruler                    " Cursor position in status line
set ignorecase               " Case-insensitive search...
set smartcase                " ...unless uppercase is typed
set hlsearch                 " Highlight search matches
set incsearch                " Incremental search
set showmatch                " Highlight matching brackets
set wildmenu                 " Command-line completion menu
set wildmode=longest:full,full
set scrolloff=8              " Keep 8 lines above/below cursor
set sidescrolloff=8
set hidden                   " Allow background buffers
set confirm                  " Ask to save instead of failing
set mouse=a                  " Enable mouse support
set updatetime=250           " Faster CursorHold (gitgutter)
set signcolumn=yes           " Always show sign column
set colorcolumn=120          " Visual marker at column 120
set cursorline               " Highlight current line

" ---------------------------------------------------------------------------
" Indentation
" ---------------------------------------------------------------------------
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" ---------------------------------------------------------------------------
" Persistent undo
" ---------------------------------------------------------------------------
if has('persistent_undo')
  set undodir=~/.vim/undodir
  set undofile
endif

" ---------------------------------------------------------------------------
" Color scheme
" ---------------------------------------------------------------------------
set background=dark
silent! colorscheme gruvbox

" ---------------------------------------------------------------------------
" Leader key
" ---------------------------------------------------------------------------
let mapleader = "\<Space>"

" ---------------------------------------------------------------------------
" Key mappings
" ---------------------------------------------------------------------------
" F2 — paste toggle
set pastetoggle=<F2>

" Window navigation with Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" Clear search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Quick save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Buffer navigation
nnoremap <leader>] :bnext<CR>
nnoremap <leader>[ :bprevious<CR>

" ---------------------------------------------------------------------------
" NERDTree settings
" ---------------------------------------------------------------------------
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
" Close vim if NERDTree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
  \ exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" ---------------------------------------------------------------------------
" Airline
" ---------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1

" ---------------------------------------------------------------------------
" Filetype-specific settings
" ---------------------------------------------------------------------------
augroup filetypes
  autocmd!
  " YAML / Ansible — 2-space indent
  autocmd FileType yaml,yml,ansible setlocal tabstop=2 shiftwidth=2 expandtab
  " Trim trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
