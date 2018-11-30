set nocompatible              " be iMproved, required

" Vundle
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'mhinz/vim-signify'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bling/vim-bufferline'
Plugin 'moll/vim-bbye'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'sjl/gundo.vim'

call vundle#end()     " required
filetype plugin on    " required

" vim-airline
let g:airline_theme="badwolf"
set ttimeoutlen=50
set laststatus=2

" NERD tree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Bbye
nnoremap <Leader>q :Bdelete<CR>

" Syntastic
let g:syntastic_cpp_compiler_options = '-std=c++17 -stdlib=libc++ -Wall -pedantic'
let g:syntastic_c_compiler_options='-O2 -Wall -Werror -Wformat-security -Wignored-qualifiers -Winit-self -Wswitch-default -Wfloat-equal -Wshadow -Wpointer-arith -Wtype-limits -Wempty-body -Wlogical-op -Wstrict-prototypes -Wold-style-declaration -Wold-style-definition -Wmissing-parameter-type -Wmissing-field-initializers -Wnested-externs -Wno-pointer-sign -std=gnu99'
let g:syntastic_python_checkers = ['python']

" Gundo
nnoremap <F5> :GundoToggle<CR>

" spaces
set autoindent
set smarttab
set tabstop=2
set shiftwidth=2
set expandtab
au BufWritePre * :%s/\s\+$//e

set list
set listchars=tab:>-

au BufNewFile,BufReadPost Makefile setl noexpandtab

set autowrite

set relativenumber
set number
set colorcolumn=100
set showcmd " display incomplete commands

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
" set background=dark
set background=dark
set incsearch

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

if &t_Co > 2 || has("gui_running")
  set hlsearch
  colorscheme solarized
endif

" Don't use Ex mode, use Q for formatting
map Q gq
