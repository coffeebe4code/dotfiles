set background=light
set t_Co=256
set updatetime=300
set signcolumn=yes
set hidden
set whichwrap+=<,>,[,]
set complete=.,w,b,u,t,i,]
set ruler
set number
set shiftwidth=2
set expandtab
set tabstop=2
set laststatus=2
set backspace=indent,eol,start
set clipboard^=unnamedplus
set shortmess+=c
set timeoutlen=1000
set completeopt=menuone,longest,noselect
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

syntax enable
let mapleader = ","

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif
au VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'ziglang/zig.vim'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

colo seoul256-light

function! SkipClosingPair()
  let line = getline('.')
  let current_char = line[col('.')-1]
  if col('.') == col('$')
  return "\<Tab>"
  end
  return stridx("}])\'\"", current_char)==-1 ? "\<Tab>" : "\<Right>"
endfunction
 
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Zig Setup
let g:zig_fmt_autosave = 0

" ALE Setup
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_linters = { 
      \ 'javascript': ['eslint'], 
      \ 'typescript': ['eslint', 'tsserver'], 
      \ 'rust': ['analyzer'], 
      \ 'zig': ['zls'], 
      \ }
let g:ale_fixers = { 
      \ 'javascript': ['eslint'], 
      \ 'typescript': ['eslint', 'prettier'], 
      \ 'json': ['prettier'], 
      \ 'css': ['prettier'], 
      \ 'html': ['prettier'], 
      \ 'yaml': ['prettier'], 
      \ 'rust': ['rustfmt'], 
      \ 'zig': ['zigfmt'], 
      \ }
let g:ale_linters_explicit = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_hover_to_preview = 1
let g:ale_fix_on_save = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" mappings.
vnoremap < <gv
vnoremap > >gv
 
nnoremap <leader>sk :m .-2<CR>
nnoremap <leader>sj :m .+1<CR>

nnoremap <space> }
vnoremap <space> }

nnoremap <BS> i<BS>
nnoremap <Del> i<Del>
nnoremap <CR> i<CR>

nnoremap <leader>p :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
 
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ SkipClosingPair()

inoremap <silent><expr> <C-j>
    \ vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' :
    \ vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' :
    \ '<C-j>'

inoremap <silent><expr> <CR>
    \ pumvisible() ? "\<C-y>" :
    \ "\<CR>"

inoremap <expr><C-p> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-p>'
 
nnoremap <C-L> :noh<CR><C-L>
nnoremap <silent><leader>cp :ALEPreviousWrap<CR>
nnoremap <silent><leader>cn :ALENextWrap<CR>
nnoremap <silent><leader>cd :ALEGoToDefinition<CR>
nnoremap <silent><leader>ci :ALEGoToImplementation<CR>
nnoremap <silent><leader>c/ :ALEFindReferences<CR>
nnoremap <silent><leader>ch :ALEHover<CR>
nnoremap <silent><leader>c. :ALECodeAction<CR>
nnoremap <silent><leader>cr :ALERename<CR>

nnoremap <silent><leader>sn :VsnipOpenVsplit<CR>

nnoremap <leader>em :MarkdownPreview<CR>
nnoremap <leader>ed :colorscheme seoul256<CR>
nnoremap <leader>el :colorscheme seoul256-light<CR>
nnoremap <leader>es :MarkdownPreviewStop<CR>

nnoremap <leader>gn :GitGutterNextHunk<CR>
nnoremap <leader>gp :GitGutterPrevHunk<CR>
nnoremap <leader>gs :GitGutterPreviewHunk<CR>
nnoremap <leader>gf :Ggqf<CR>
nnoremap <leader>gu :GitGutterUndoHunk<CR>
nnoremap <leader>gd :GitGutterDiffOrig<CR>

command! Ggqf :GitGutterQuickFix | copen
