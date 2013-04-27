set nocompatible
autocmd! BufWritePost .vimrc source %
" Bundles: {{{
filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Raimondi/delimitMate'
Bundle 'ervandew/supertab'
Bundle 'groenewege/vim-less'
Bundle 'othree/html5.vim'
Bundle 'mattn/zencoding-vim'
Bundle 'surround.vim'

Bundle 'jellybeans.vim'
let g:delimitMate_expand_cr = 1

filetype plugin indent on
" }}}
" System {{{
set nomodeline 
set visualbell
set lazyredraw ttyfast
set hidden
set nobackup noswapfile nowritebackup viminfo=
set autoread autochdir
set confirm
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
set nohlsearch incsearch ignorecase smartcase 
set gdefault magic
set wildmenu wildmode=full
set complete=.,w,b,u,t
set completeopt=menuone,preview
set scrolloff=7
set foldmethod=marker
set wrap linebreak textwidth=0 wrapmargin=0
" }}}
" Visuals, colors and themes {{{
syntax on

set noshowmatch 
set showcmd showmode relativenumber 
set laststatus=2
set statusline=[%n]%<%f\ %y[%{&ff}][%{&fenc}]\ %m%r%w%a\ %=%l/%L,%c%V\ %P\ %#Folded#%{getcwd()}

if &t_Co == 256
	colorscheme jellybeans
	set cursorline
	set colorcolumn=80
	set listchars=tab:▸\ ,eol:¬
else
	colorscheme desert
	highlight MatchParen ctermfg=none ctermbg=blue
endif

if &term =~ 'screen'
	au BufEnter * let &titlestring = "[" . expand("%:t") . "]"
	set t_ts=k
	set t_fs=\
	set title
endif
" }}}
" Mapping {{{
let mapleader = ","
no ; :
no \ ;
no 0 ^
no ^ 0
no ' `
no ` '

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

" Taken from http://stackoverflow.com/a/8459043
command! -bang Bufo :call DeleteHiddenBuffers('<bang>')

function! DeleteHiddenBuffers(bang)
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        execute 'confirm bwipeout' .a:bang. buf
    endfor
endfunction
"}}}
" C/C++ {{{
" Sandbox one-file projects. Read custom modeline for gcc flags.
function! Gcc()
	let flags = get(matchlist(getline(1), 'gcc:\(.*\):'), 1, '-Wall')
	let &l:makeprg = 'gcc %:p -o/tmp/%:t:r ' .flags
	no <buffer> <F5> :make \| !/tmp/%:t:r && rm /tmp/%:t:r<CR>
endfunction
au BufReadPost,BufWritePost ~/src/sandbox/*.c call Gcc()
au FileType c setlocal foldmethod=syntax
" }}}
" LESS, CSS, HTML, PHP, JavaScript {{{
au FileType less setlocal omnifunc=csscomplete#CompleteCSS smartindent
au FileType html setlocal omnifunc=zencoding#CompleteTag sw=2 ts=2
let g:php_folding=2
" }}}
" Firefox Extensions {{{
au BufReadPost,BufWritePost ~/src/firefox/** map <silent> <F5> :!firefox -new-instance -P dev &<CR><CR>
" }}}
