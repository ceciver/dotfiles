" Core Vim settings adapted from the Neovim config in .config/nvim.
set nocompatible
let mapleader = ' '

set number relativenumber
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smartindent
set nowrap colorcolumn=80
set noswapfile nobackup undofile
set nohlsearch incsearch
set scrolloff=8 updatetime=50
set foldmethod=marker foldmarker={{{,}}} foldlevel=0 foldlevelstart=0 foldenable foldcolumn=1
set iskeyword-=_
if exists('+termguicolors')
  set termguicolors
endif
if exists('+signcolumn')
  set signcolumn=yes
endif

let s:undo_dir = expand('~/.vim/undodir')
if !isdirectory(s:undo_dir)
  call mkdir(s:undo_dir, 'p')
endif
let &undodir = s:undo_dir
unlet s:undo_dir

syntax on
filetype plugin indent on

nnoremap <leader>pv :Ex<CR>
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
xnoremap <leader>p "_dP
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>d "_d
xnoremap <leader>d "_d
inoremap <C-c> <Esc>
nnoremap Q <Nop>
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <silent> <leader>x :!chmod +x %<CR>
nnoremap <leader><leader> :source $MYVIMRC<CR>

augroup ceciver_vim
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END
