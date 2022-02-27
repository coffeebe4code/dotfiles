set background=dark
set t_Co=256
set nocompatible
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set signcolumn=yes
set hidden
set whichwrap+=<,>,[,]
set complete=.,w,b,u,t,i,]
set ignorecase
set ruler
set number
set shiftwidth=2
set expandtab
set tabstop=2
set laststatus=2
set backspace=indent,eol,start
set clipboard^=unnamedplus
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
set cursorline
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/bin/*,*/out/*,*/target/*
set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep\ $*
set grepformat^=%f:%l:%c:%m
set noswapfile
set re=0
set nobackup
set nowritebackup
set makeprg=./nobuild

au FileType rust compiler rs

hi PmenuSel ctermbg=black ctermfg=Cyan
hi CocFloating ctermbg=black ctermfg=Cyan
syntax enable

set noeb vb t_vb=

let mapleader = ","
 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plug Install automatically
au VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif
call plug#begin()

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
 
call plug#end()

au CursorHold * silent call CocActionAsync('highlight')

" functions
function! SkipClosingPair()
  let line = getline('.')
  let current_char = line[col('.')-1]
  if col('.') == col('$')
  return "\<Tab>"
  end
  return stridx("}])\'\"", current_char)==-1 ? "\<Tab>" : "\<Right>"
endfunction
 
function! SkipCheckAndRefresh()
  let z = coc#refresh()
  return SkipClosingPair()
endfunction
 
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
 
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
  execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
  call CocActionAsync('doHover')
  else
  execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" mappings.
nnoremap dd "_dd
vnoremap d "_d<Esc>
vnoremap < <gv
vnoremap > >gv
 
nnoremap <leader>sk :m .-2<CR>
nnoremap <leader>sj :m .+1<CR>
xmap <C-c> "+y<Esc>
nnoremap <C-p> "*p<Esc>
nnoremap c "3c
nnoremap C "3C
nnoremap d "4d
nnoremap D "4D

nnoremap <BS> i<BS>
nnoremap <Del> i<Del>
nnoremap <CR> i<CR>

nnoremap <leader>p :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>ts :tabs<CR>
nnoremap <leader>te :tabedit<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>tn :tabn<CR>
 
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>\<C-y>" :
    \ <SID>check_back_space() ? "\<Tab>"  :
    \ SkipCheckAndRefresh()
 
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <C-space> coc#refresh()
 
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
 
nnoremap <C-L> :noh<CR><C-L>
nnoremap <silent><leader>cp <Plug>(coc-diagnostic-prev)
nmap <silent><leader>cy <Plug>(coc-type-definition)
nmap <silent><leader>cn <Plug>(coc-diagnostic-next)
nmap <silent><leader>cd <Plug>(coc-definition)
nmap <silent><leader>ci <Plug>(coc-implmentation)
nmap <silent><leader>c/ <Plug>(coc-references)
nmap <silent><leader>ch :call <SID>show_documentation()<CR>

nmap <leader>c. <Plug>(coc-codeaction)
nmap <leader>mc :make --clean<CR>
nmap <leader>md :make<CR>
nmap <leader>mr :make --release<CR>
nmap <leader>ma :make --add 
nmap <leader>mi :make --incremental %<CR> 
nnoremap <silent><leader>ch :call <SID>show_documentation()<CR>
nmap <leader>cr <Plug>(coc-rename)
xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf :Format<CR>

nmap <leader>cb :!gcc -Wall -Wextra -Werror -std=c11 -o ./nobuild ./nobuild.c<CR>

nmap <leader>sl :Sl<space>
nmap <leader>sr :Sr<space>
nmap <leader>sn :CocCommand snippets.editSnippets<CR>
nmap <leader>da [c
nmap <leader>dd ]c
nmap <leader>dp :diffput<CR>
nmap <leader>dg :diffget<CR>
nmap <leader>dr :diffget REMOTE<CR>
nmap <leader>db :diffget BASE<CR>
nmap <leader>dl :diffget LOCAL<CR>
nmap <leader>ds :w !diff % -<CR>
nmap <leader>dm /\|=======\|<CR> 
nmap <leader>cl !silent :%s/^$\n//<CR>

nmap <leader>r :reg<CR>
nnoremap <leader>n :n<CR>
nnoremap <space> }
nnoremap <leader><space> {
xnoremap <C-a> <C-a>gv
xnoremap <C-x> <C-x>gv

" Git mappings
nnoremap <leader>ga :!git add %<CR>
nnoremap <leader>gd :!git diff %<CR>

highlight DiffAdd  cterm=NONE ctermfg=NONE ctermbg=22
highlight DiffDelete cterm=NONE ctermfg=NONE ctermbg=52
highlight DiffChange cterm=NONE ctermfg=NONE ctermbg=23
highlight DiffText   cterm=NONE ctermfg=NONE ctermbg=23

function FormatBuffer()
  if &modified 
    let cursor_pos = getpos('.')
    :%!clang-format
    call setpos('.', cursor_pos)
  endif
endfunction

autocmd BufWritePre *.h,*.c :call FormatBuffer()

function! SearchLiteral(search_glob) abort
  let g:literal_search = a:search_glob
  execute "silent! grep! " . g:literal_search . ""
  copen
endfunction
 
function! SearchReplace(new) abort
  execute 'cdo s/' . g:literal_search . '/' . a:new
endfunction

command! -nargs=0 Format :call CocAction('format')
command! -nargs=* Sl :call SearchLiteral(<q-args>)
command! -nargs=1 Sr :call SearchReplace(<f-args>)
