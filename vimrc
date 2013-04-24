set nocompatible
filetype off
autocmd! bufwritepost .vimrc source %
" Bundles {{{
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'xoria256.vim'
Bundle 'SuperTab'
Bundle 'git://github.com/lunaru/vim-less.git'
Bundle 'AutoClose'

let g:netrw_list_hide= '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_preview = 1

" }}}
" System {{{
set nomodeline 
set visualbell
set lazyredraw ttyfast
set autoread
set hidden
set nobackup noswapfile nowritebackup viminfo=
filetype plugin indent on
" }}}
" Language and encodings {{{
set keymap=russian-jcukenwin " Switch keymap with i_CTRL-^
set iminsert=0 imsearch=-1 
set encoding=utf-8              " internal
set fileencoding=utf-8          " new buffer
set fileencodings=utf-8,cp1251  " autodetect (see ++enc)
set fileformat=unix
set spelllang=en,ru
" }}}
" Editor {{{
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 noexpandtab
set hlsearch incsearch ignorecase smartcase 
set gdefault magic
set wildmenu wildmode=longest,full
set completeopt=menuone,preview,longest
set scrolloff=7
set foldmethod=marker
set wrap linebreak textwidth=0 wrapmargin=0
" }}}
" Visuals, colors and themes {{{
syntax on

set noshowmatch 
set showcmd showmode relativenumber 
set laststatus=2
set statusline=[%n]%<%F\ %y[%{&ff}]\ %m%r%w%a\ %=%l/%L,%c%V\ %P\ %#IncSearch#%{getcwd()}

if &t_Co == 256
	colorscheme xoria256
	highlight CursorLine  ctermbg=233
	highlight ColorColumn ctermbg=233
	set cursorline
	set colorcolumn=80
	set listchars=tab:▸\ ,eol:¬
else
	colorscheme desert
	highlight MatchParen ctermfg=none ctermbg=blue
endif
" }}}
" Mapping {{{

let mapleader = ","
no ; :
no \ ;
vn 0 ^
no ^ 0

set wildcharm=<c-z>
no <leader>e<tab> :e <c-z>
no <leader>ev :e $MYVIMRC<cr>

no * *N
no <leader><space> :nohl<CR>
no <leader>i :set list!<CR>
no <leader>s :set spell!<CR>
set pastetoggle= " ctrl &
ino <expr> <nul> "\<C-x>\<C-o>"

" buffers and windows
no  gb :bnext<CR>
no  gB :bprev<CR>
no  <leader>d :bd<CR>
no  <leader>l :ls<CR>
no  <c-s> :w<CR>
ino <c-s> <ESC>:w<CR>
no  <leader><leader> <c-^>
no  <leader><tab> :b <c-z>

" force 'hjkl' motion
ino  <Up>     <nop>
ino  <Down>   <nop>
ino  <Left>   <nop>
ino  <Right>  <nop>
no   <Up>     <c-w><c-k>
no   <Down>   <c-w><c-j>
no   <Left>   <c-w><c-h>
no   <Right>  <c-w><c-l>

" browser-like scrolling
no   <Space>  <PageDown>
no   -        <PageUp>
no j gj
no k gk

" OS integration
vn <leader>y y:call system("xclip -i -sel clip", getreg("\""))<CR>
no <leader>p :r !xclip -o -sel clip<CR>
no <leader>P :-1r !xclip -o -sel clip<CR>

command! W w !sudo tee % > /dev/null
"}}}
" C/C++ {{{
" Sandbox one-file projects. Read custom modeline for gcc flags.
function! Gcc()
	let flags = get(matchlist(getline(1), 'gcc:\(.*\):'), 1, '-Wall')
	let &l:makeprg = 'gcc %:p -o/tmp/%:t:r ' .flags
	nmap <buffer> <F5> :make \| !/tmp/%:t:r && rm /tmp/%:t:r<CR>
endfunction
au BufReadPost,BufWritePost ~/src/sandbox/*.c call Gcc()
au FileType c setlocal foldmethod=syntax
" }}}
" LESS {{{
au FileType less set noautoindent nosmartindent cindent
au FileType less set omnifunc=csscomplete#CompleteCSS
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" }}}
" PHP {{{ 
let g:php_folding=2
" }}}
