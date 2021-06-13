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
set grepprg=ag\ --vimgrep
 
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
vmap <C-c> "+y<Esc>
nnoremap <BS> i<BS>
nnoremap <Del> i<Del>
nnoremap <CR> i<CR>
nnoremap dd "_dd

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
 
inoremap( ()<Left>
inoremap' ''<Left>
inoremap" ""<Left>
inoremap[ []<Left>
 
nnoremap <C-L> :noh<CR><C-L>
nmap <silent><leader>la <Plug>(coc-diagnostic-prev)
nmap <silent><leader>ld <Plug>(coc-diagnostic-next)
nmap <silent><leader>lj <Plug>(coc-definition)
nmap <silent><leader>l/ <Plug>(coc-references)
 
nnoremap <silent><leader>lh :call <SID>show_documentation()<CR>
 
nmap <leader>lr <Plug>(coc-rename)
 
xmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>l. <Plug>(coc-codeaction)
 
nmap <leader>sl :Sl<space>
nmap <leader>sr :Sr<space>
nmap <leader>sn :CocCommand snippets.editSnippets<CR>
nmap <leader>da [c
nmap <leader>dd ]c
nmap <leader>dp :diffput<CR>
nmap <leader>dg :diffget<CR>
nmap <leader>dr :diffget RE<CR>
nmap <leader>db :diffget BA<CR>
nmap <leader>dl :diffget LO<CR>
nmap <leader>ds :w !diff % -<CR>
 
nmap <leader>cl !silent :%s/^$\n//<CR>
 
highlight DiffAdd  cterm=NONE ctermfg=NONE ctermbg=22
highlight DiffDelete cterm=NONE ctermfg=NONE ctermbg=52
highlight DiffChange cterm=NONE ctermfg=NONE ctermbg=23
highlight DiffText   cterm=NONE ctermfg=NONE ctermbg=23
 
function! SearchLiteral(search_glob) abort
  let g:literal_search = a:search_glob
  execute "silent! grep! " . g:literal_search . ""
  copen
endfunction
 
function! SearchReplace(new) abort
  execute 'cdo s/' . g:literal_search . '/' . a:new . '/ge | update'
endfunction
 
command! -nargs=0 Format :call CocAction('format')
command! -nargs=* Sl :call SearchLiteral(<q-args>)
command! -nargs=1 Sr :call SearchReplace(<f-args>)
