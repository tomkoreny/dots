" if &compatible set nocompatible
" endif

"let g:python_host_prog  = '/usr/bin/python2'
"let g:python3_host_prog  = '/usr/bin/python'

let mapleader = "\<Space>" 

call plug#begin(stdpath('data') . '/plugged')
 Plug 'sheerun/vim-polyglot'
 Plug 'scrooloose/nerdcommenter'
 Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
 Plug 'junegunn/fzf.vim'
 Plug 'tpope/vim-surround'
 Plug 'Shougo/deoplete.nvim'
 " Plug 'bdauria/angular-cli.vim'
 Plug 'tpope/vim-fugitive'
 Plug 'jiangmiao/auto-pairs'
 " Plug 'Shougo/neco-vim'
 " Plug 'mhinz/vim-startify'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'Shougo/denite.nvim'
 " Plug 'neoclide/coc.nvim', {'branch': 'release'}
 " Plug 'dylanaraps/wal.vim'
 Plug 'arcticicestudio/nord-vim'
 Plug 'neovim/nvim-lsp'
 Plug 'ervandew/supertab'
 Plug 'ncm2/float-preview.nvim'
 " Plug 'honza/vim-snippets'
 " Plug 'paulkass/jira-vim'
call plug#end()

luafile ~/.config/nvim/config.lua
setlocal omnifunc=v:lua.vim.lsp.omnifunc
imap <tab> <c-x><c-o>
let g:float_preview#docked = 0

if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
  autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
endif

set mouse+=a

autocmd VimEnter * if globpath('.,..','node_modules/@angular') != '' | call angular_cli#init() | endif


let g:jiraVimDomainName = "https://singlecase.atlassian.net"
let g:jiraVimEmail = "tomas.koreny@snowlycode.com"
let g:jiraVimToken = "8pEOsS494n3bVJgj7hSo9F90"

augroup jiravim_keybinds
  autocmd!
  autocmd FileType jirakanbanboardview nnoremap <buffer> <localleader>si JiraVimSelectIssueSp
  autocmd FileType jirakanbanboardview, jirasprintview nnoremap <buffer> <localleader>lm JiraVimLoadMore
augroup END

let g:NERDTreeMinimalUI = 1 

" let g:coc_global_extensions = ['coc-angular', 'coc-snippets', 'coc-marketplace', 'coc-tsserver', 'coc-tslint', 'coc-stylelint', 'coc-html', 'coc-tag', 'coc-prettier', 'coc-yaml', 'coc-json', 'coc-css', 'coc-sh', 'coc-vimtex', 'coc-go', 'coc-git']

let g:NERDSpaceDelims = 1

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Better netrw settings, we use NERDTree instead, but its still nice
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15

filetype plugin indent on
syntax on

set hidden
set rtp+=/usr/local/opt/fzf
set noshowmode
set relativenumber
set number
" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When on uses space instead of tabs
set tabstop     =2
set softtabstop =2
set shiftwidth  =2
set expandtab 

colorscheme nord
let g:airline_theme='nord'

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

set colorcolumn=80,120
" imap <TAB>     <Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-k>     <Plug>(neosnippet_expand_target)
"
nnoremap <leader>w  :write<CR>

" QUICKLY JUMP BETWEEN FILES AND BUFFERS
nnoremap <leader>fb  :Buffers<CR>
nnoremap <leader>fg  :GFiles<CR>
nnoremap <leader>fo  :Files<CR>
nnoremap <leader>ft  :term<CR>
" nnoremap <C-p> :Buffers<CR>
" nnoremap <C-z> :GFiles<CR>
" nnoremap <C-i> :Files<CR>

" QUICK GIT ACTIONS
nnoremap <leader>g :G<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gu :GFiles?<CR>

" QUICK CODE ACTION
" nmap <leader>ce  <Plug>(coc-codeaction)
" nmap <leader>cr <Plug>(coc-rename)
" nmap <leader>cf <Plug>(coc-format)
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>
nnoremap <C-n> :EComponent 
nnoremap <C-m> :ETemplate 
nnoremap <C-b> :EStyle 

tnoremap <Esc> <C-\><C-n>


tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" autocmd CursorHoldI,CursorMovedI * silent! call CocAction('showSignatureHelp')

" function! s:show_documentation()
  " if &filetype == 'vim'
    " execute 'h '.expand('<cword>')
  " else
    " call CocAction('doHover')
  " endif
" endfunction
set cmdheight=2

" WRITE SPECIAL LETTERS {{{
imap =a á
imap =A Á
imap +a ä
imap +A Ä
imap +c č
imap +C Č
imap +d ď
imap +D Ď
imap =e é
imap +e ě
imap =E É
imap +E Ě
imap =i í
imap =I Í
imap =l ĺ
imap =L Ĺ
imap +l ľ
imap +L Ľ
imap +n ň
imap +N Ň
imap =o ó
imap =O Ó
imap +o ô
imap +O Ô
imap "o ö
imap "O Ö
imap =r ŕ
imap =R Ŕ
imap +r ř
imap +R Ř
imap +s š
imap +S Š
imap +t ť
imap +T Ť
imap =u ú
imap =U Ú
imap +u ů
imap +U Ů
imap "u ü
imap "U Ü
imap =y ý
imap =Y Ý
imap +z ž
imap +Z Ž
" }}}


:nnoremap <leader>vr :vertical resize 100<CR>
:nnoremap <leader>ev :vsplit ~/.config/nvim/init.vim<CR>
:nnoremap <leader>sv :wq<CR>:source ~/.config/nvim/init.vim<CR>
:inoremap jk <esc>

"Opn fzf in floating window
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = &lines - 3
  let width = float2nr(&columns - (&columns * 2 / 10))
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': 1,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" inoremap <silent><expr> <TAB>
      " \ pumvisible() ? coc#_select_confirm() :
      " \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
