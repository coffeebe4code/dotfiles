set background=dark
set t_Co=256
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
set timeoutlen=1000
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
set noswapfile
set re=0
set nobackup
set nowritebackup
set makeprg=./nobuild
set errorformat+=%.%#[FAIL]%.%#file:\ %f\ =>\ line:\ %l%m%.%#
set errorformat+=%.%#[ERRO]%m%.%#
set errorformat+=%-G%.%#

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

Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

call plug#end()

let g:seoul256_background = 236

colo seoul256

let g:goyo_width=120

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
vnoremap < <gv
vnoremap > >gv
 
nnoremap <leader>sk :m .-2<CR>
nnoremap <leader>sj :m .+1<CR>
nnoremap <space> }

nnoremap <BS> i<BS>
nnoremap <Del> i<Del>
nnoremap <CR> i<CR>

nnoremap <leader>p :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
 
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>\<C-y>" :
    \ <SID>check_back_space() ? "\<Tab>"  :
    \ SkipCheckAndRefresh()
 
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <C-space> coc#refresh()
 
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
 
nnoremap <C-L> :noh<CR><C-L>
nmap <silent><leader>cp :call CocAction('diagnosticPrevious')<CR>
nmap <silent><leader>cy <Plug>(coc-type-definition)
nmap <silent><leader>cn <Plug>(coc-diagnostic-next)
nmap <silent><leader>cd <Plug>(coc-definition)
nmap <silent><leader>ci <Plug>(coc-implmentation)
nmap <silent><leader>c/ <Plug>(coc-references)
nmap <silent><leader>ch :call <SID>show_documentation()<CR>
nmap <silent><leader>c. <Plug>(coc-codeaction)
nmap <silent><leader>cr <Plug>(coc-rename)
xmap <silent><leader>cf <Plug>(coc-format-selected)
nmap <silent><leader>cf :Format<CR>
nmap <leader>cb :!gcc -Wall -Wextra -Werror -O3 -pthread -o ./nobuild ./nobuild-gcc.c<CR>

nmap <leader>mc :make --clean<CR>
nmap <leader>md :make --debug<CR>
nmap <leader>ms :make --debug --skip-tests<CR>
nmap <leader>mr :make --release<CR>
nmap <leader>ma :make --add 
nmap <leader>me :make --exe 
nmap <leader>mb :make --build %<CR>
nmap <leader>mt :!./target/e2e<CR>

nmap <leader>eg :Goyo<CR> 
nmap <leader>em :MarkdownPreview<CR>
nmap <leader>es :MarkdownPreviewStop<CR>

nmap <leader>sn :CocCommand snippets.editSnippets<CR>

hi DiffAdd  cterm=NONE ctermfg=NONE ctermbg=22
hi DiffDelete cterm=NONE ctermfg=NONE ctermbg=52
hi DiffChange cterm=NONE ctermfg=NONE ctermbg=23
hi DiffText   cterm=NONE ctermfg=NONE ctermbg=23

hi PmenuSel ctermbg=black ctermfg=Cyan
hi CocFloating ctermbg=black ctermfg=Cyan
hi WildMenu ctermbg=white ctermfg=black
hi Pmenu ctermbg=white ctermfg=black

function FormatBuffer()
  if &modified 
    let cursor_pos = getpos('.')
    :%!clang-format
    call setpos('.', cursor_pos)
  endif
endfunction

autocmd BufWritePre *.h,*.c :call FormatBuffer()
autocmd BufWritePre *.json,*.ts,*.js :call CocAction('format')

command! -nargs=0 Format :call CocAction('format')
