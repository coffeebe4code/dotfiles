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
set shiftwidth=0
set softtabstop=-1
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
set cursorline
set wildignore+=**/node_modules/**,**/.git/**,**/dist/**,**/bin/**

hi PmenuSel ctermbg=black ctermfg=Cyan
syntax enable
set noeb vb t_vb=

set laststatus=2
set statusline=\ %-10.10{StatusLineColor()}
set statusline+=%-7.7{&modified?'-[+]-':'-\|-'}
set statusline+=%-20.20F
set statusline+=%-7.7y

let g:currentmode={
      \ 'n'  : ['Normal ','yellow'],
      \ 'v'  : ['Visual ', 'cyan'],
      \ 'V'  : ['V·Line ', 'cyan'],
      \ '^V' : ['V·Block ', 'cyan'],
      \ 'i'  : ['Insert ','green'],
      \ 'R'  : ['Replace ','red'],
      \ 'Rv' : ['V·Replace ','red'],
      \ 'c'  : ['Command ','magenta'],
      \ 'r?' : ['Confirm ', 'green'],
      \ 't'  : ['Terminal ', 'magenta']}

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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

au CursorHold * silent call CocActionAsync('highlight')

" functions
function! StatusLineColor()
	execute 'hi statusline ctermfg=' . g:currentmode[mode()][1]
	return toupper(g:currentmode[mode()][0])
endfunction

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

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap ( ()<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap [ []<Left>

nnoremap <C-L> :noh<CR><C-L>
nmap <silent><leader>la <Plug>(coc-diagnostic-prev)
nmap <silent><leader>ld <Plug>(coc-diagnostic-next)
nmap <silent><leader>lj <Plug>(coc-definition)
nmap <silent><leader>l/ <Plug>(coc-references)
nnoremap <silent><leader>lJ :call <SID>show_documentation()<CR>
nmap <leader>lr <Plug>(coc-rename)

xmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>l. <Plug>(coc-codeaction)

nmap <leader>sl :Sl<space>
nmap <leader>sr :Sr<space>
nmap <leader>ga [c
nmap <leader>gd c]
nmap <leader>gp :diffput
nmap <leader>gg :diffget
nmap <leader>gr :diffget RE
nmap <leader>gb :diffget BA
nmap <leader>gl :diffget LO

function! SearchLiteral(search_glob) abort
	let g:literal_search = join(split(a:search_glob)[0:-2])
	let l:glob = split(a:search_glob)[-1]
	execute 'vimgrep /' . g:literal_search . '/gj' . l:glob
	execute 'copen'
endfunction

function! SearchReplace(new) abort
  execute 'cfdo %s/' . g:literal_search . '/' . a:new . '/ge | update'
endfunction
 
command! -nargs=0 Format :call CocAction('format')
command! -nargs=* Sl :call SearchLiteral(<q-args>)
command! -nargs=1 Sr :call SearchReplace(<f-args>)
