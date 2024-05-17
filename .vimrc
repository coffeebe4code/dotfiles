set signcolumn=yes
set whichwrap+=<,>,h,l,[,]
set ruler
set number
set shiftwidth=2
set expandtab
set tabstop=2
set laststatus=2
set backspace=indent,eol,start
set clipboard^=unnamed "unnamedplus
set completeopt=menuone,longest,noselect,noinsert
set hlsearch
set incsearch
set showmatch
set splitbelow
set splitright
set wildmenu
set wildmode=list:longest,longest:full
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/bin/*,*/out/*,*/target/*
set noswapfile
set re=0
set noeb vb t_vb=
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

syntax enable
let mapleader = ","

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif
au VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))| PlugInstall --sync | source $MYVIMRC | endif

call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'
Plug 'coffeebe4code/type-lang.vim'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

colo seoul256-light

let g:ale_linters_explicit = 1
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_hover_to_preview = 1
let g:ale_fix_on_save = 1
let g:ale_linters = {  'javascript': ['eslint', 'tsserver'], 'typescript': ['eslint', 'tsserver'], 
                    \ 'rust': ['analyzer'], 'zig': ['zls']
                    \ }
let g:ale_fixers = {  'javascript': ['prettier'], 'typescript': ['prettier'], 
                    \ 'json': ['prettier'], 'css': ['prettier'], 'html': ['prettier'], 
                    \ 'yaml': ['prettier'], 'rust': ['rustfmt'], 'zig': ['zigfmt'], 
                    \ }

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap <C-L> :noh<CR><C-L>
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>b :Buffers<CR>

nnoremap <silent><leader>cp :ALEPreviousWrap<CR>
nnoremap <silent><leader>cn :ALENextWrap<CR>
nnoremap <silent><leader>cd :ALEGoToDefinition<CR>
nnoremap <silent><leader>ci :ALEGoToImplementation<CR>
nnoremap <silent><leader>c/ :ALEFindReferences<CR> 
nnoremap <silent><leader>ch :ALEHover<CR>
nnoremap <silent><leader>c. :ALECodeAction<CR>
nnoremap <silent><leader>cr :ALERename<CR>
nnoremap <leader>ev :e ~/.vimrc<CR>
nnoremap <leader>ed :colorscheme seoul256<CR>
nnoremap <leader>el :colorscheme seoul256-light<CR>
nnoremap <leader>gn :GitGutterNextHunk<CR>
nnoremap <leader>gp :GitGutterPrevHunk<CR>
nnoremap <leader>gs :GitGutterPreviewHunk<CR>
nnoremap <leader>gg :GitGutterQuickFix<BAR> copen<CR>
nnoremap <leader>gu :GitGutterUndoHunk<CR>
nnoremap <leader>gd :GitGutterDiffOrig<CR>
nnoremap <leader>dm /=======<CR>
nnoremap <leader>dn ]c
nnoremap <leader>dr :diffget RE<CR>
nnoremap <leader>dl :diffget LO<CR>
nnoremap <leader>db :diffget BASE<CR>
