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
set tabstop=1
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
set cursorline

highlight CursorLine ctermbg=black
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

let g:user_emmet_leader_key=","

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'mattn/emmet-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap { {}<Left>
inoremap ( ()<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap [ []<Left>

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

function! SkipCheckAndRefresh()
	let z = coc#refresh()
	return SkipClosingPair()
endfunction

" mappings.
vmap <C-c> "+y<Esc>
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>f :Format<CR>
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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent><leader>la <Plug>(coc-diagnostic-prev)
nmap <silent><leader>ld <Plug>(coc-diagnostic-next)
nmap <silent><leader>lj <Plug>(coc-definition)
nmap <silent><leader>l/ <Plug>(coc-references)
nnoremap <silent><leader>lJ :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nmap <leader>lr <Plug>(coc-rename)
xmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>l. <Plug>(coc-codeaction)

function! SearchAndSet(search, glob) abort
				let g:search_and_set_search = a:search
				execute 'vimgrep /' . a:search . '/gj' . a:glob
				execute 'copen'
endfunction

function! ReplaceFromSearch(new) abort
				execute 'cfdo %s/' . g:search_and_set_search . '/' . a:new . '/ge | update'
endfunction

function! SearchAndReplace(old, new, glob) abort
				execute 'vimgrep /' . a:old . '/gj ' . a:glob
        execute 'cfdo %s/' . a:old . '/' . a:new . '/ge | update'
endfunction

command! -nargs=0 Format :call CocAction('format')
command! -nargs=* Sr :call SearchAndReplace(<f-args>)
command! -nargs=* Ss :call SearchAndSet(<f-args>)
command! -nargs=1 Rs :call ReplaceFromSearch(<f-args>)

