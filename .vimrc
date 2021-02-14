set nocompatible
set whichwrap+=<,>,[,]
set complete=.,w,b,u,t,i,]
set ignorecase
set ruler
set number
set tabstop=2
set laststatus=2
set backspace=indent,eol,start
set clipboard=unnamedplus
set shortmess+=c
set timeoutlen=3000
set completeopt=menuone,longest
set hlsearch
set incsearch
set showmatch
set splitbelow
set splitright
set wildmenu
set wildmode=list:longest,longest:full

highlight PmenuSel ctermbg=DarkMagenta guifg=Cyan ctermfg=Cyan guibg=DarkMagenta
syntax enable
" disable bells
set noeb vb t_vb=

let mapleader = ","

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plug Install automatically
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

set omnifunc=ale#completion#OmniFunc
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
												\ 'rust':['rustfmt'],
												\}
let g:ale_linters = {
												\ 'rust':['analyzer'],
												\}

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
Plug 'vim-scripts/AutoComplPop'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'

call plug#end()

inoremap { {}<Left>
inoremap ( ()<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap [ []<Left>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <Tab> pumvisible() ? '<C-y>' : SkipClosingPair()

nnoremap <leader>cb :vert :term cargo build<CR><C-w><C-w>
nnoremap <leader>cr :vert :term cargo run<CR><C-w><C-w>
nnoremap <leader>nt :vert :term npm run test<CR><C-w><C-w>
nnoremap <leader>nr :vert :term npm run start<CR><C-w><C-w>

" functions
function! SkipClosingPair()
  let line = getline('.')
  let current_char = line[col('.')-1]
	"there is more"
  "Ignore EOL
  if col('.') == col('$')
    return "\<Tab>"
  end
  return stridx("}])\'\"", current_char)==-1 ? "\<Tab>" : "\<Right>"
endfunction

" mappings.
vmap <C-c> "+y<Esc>
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>ts :tabs<CR>
nnoremap <leader>te :tabedit<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>tn :tabn<CR>

nmap <silent> <leader>lg :ALEGoToDefinition<CR>
nmap <silent> <leader>l. :ALECodeAction<CR>
nmap <silent> <leader>ls :ALESymbolSearch<CR>
nmap <silent> <leader>lr :ALERename<CR>
nmap <silent> <leader>lh :ALEHover<CR>
nmap <silent> <leader>l/ :ALEFindReferences<CR>
nmap <silent> <leader>la <Plug>(ale_previous_wrap)
nmap <silent> <leader>ld <Plug>(ale_next_wrap)

nnoremap <silent> <leader>ww <C-w>w<CR>
nnoremap <silent> <leader>wh <C-w>h<CR>
nnoremap <silent> <leader>wj <C-w>j<CR>
nnoremap <silent> <leader>wk <C-w>k<CR>
