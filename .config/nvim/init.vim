"       __                   ______                        
"      / /   ____  _________/ / __ \__  ______ ___  ____ _ 
"     / /   / __ \/ ___/ __  / /_/ / / / / __ `__ \/ __ `/ 
"    / /___/ /_/ / /  / /_/ / ____/ /_/ / / / / / / /_/ /  
"   /_____/\____/_/   \__,_/_/    \__,_/_/ /_/ /_/\__,_/   
"
" This is NVIM config by T.Koreny (@lordpuma)

let mapleader = "\<Space>" 

call plug#begin(stdpath('data') . '/plugged')
Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/diagnostic-nvim'
Plug 'haorenW1025/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'junegunn/fzf.vim'
Plug 'jbgutierrez/vim-better-comments'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'neomake/neomake'
"Plug 'StanAngeloff/php.vim', {'for': 'php'}
call plug#end()

set mouse+=a
set termguicolors

if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
  autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
endif

:lua << EOF
  local nvim_lsp = require('nvim_lsp')

  local on_attach =
 function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require'diagnostic'.on_attach()
    require'completion'.on_attach()

    -- Mappings.
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  end

  local servers = {'gopls', 'rust_analyzer', 'sumneko_lua', 'tsserver', 'vimls', 'jsonls', 'pyls_ms', 'html', 'cssls', 'intelephense'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end

  require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,                    -- false will disable the whole extension
    },
    refactor = {
      highlight_definitions = { enable = true },
--      highlight_current_scope = { enable = true },
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
    ensure_installed = 'all' -- one of 'all', 'language', or a list of languages
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

command! -buffer -nargs=0 LspShowLineDiagnostics lua require'jumpLoc'.openLineDiagnostics()
nnoremap <buffer><silent> <C-h> <Cmd>LspShowLineDiagnostics<CR>

let g:diagnostic_auto_popup_while_jump = 1
let g:completion_enable_snippet = 'UltiSnips'

command! Format  execute 'lua vim.lsp.buf.formatting()'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c


" Auto close popup menu when finish completion
" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Use tab as trigger key
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

" Chain completion list
let g:completion_chain_complete_list = {
            \ 'default' : {
            \   'default': [
            \       {'complete_items': ['lsp', 'snippet']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   'string' : [{'complete_items': ['path']}]}}

let g:UltiSnipsExpandTrigger="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

autocmd BufWritePre *.ts,*.tsx lua vim.lsp.buf.formatting()

" QUICKLY JUMP BETWEEN FILES AND BUFFERS
nnoremap <leader>fb  :Buffers<CR>
nnoremap <leader>fg  :GFiles<CR>
nnoremap <leader>fo  :Files<CR>
nnoremap <leader>ft  :term<CR>

colorscheme PaperColor
let g:airline_theme='papercolor'

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15

filetype plugin indent on
syntax on

set hidden
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

"set colorcolumn=80,120
"
nnoremap <leader>w  :write<CR>

" QUICKLY JUMP BETWEEN FILES AND BUFFERS
nnoremap <leader>fb  :Buffers<CR>
nnoremap <leader>fg  :GFiles<CR>
nnoremap <leader>fo  :Files<CR>
nnoremap <leader>ft  :term<CR>

" QUICK GIT ACTIONS
nnoremap <leader>g :G<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gu :GFiles?<CR>

nnoremap <F7> :NERDTreeToggle<CR>

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


"Open fzf in floating window
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

command! Start  vsplit term://npm start
command! Test  vsplit term://npm test
command! Story  vsplit term://npm storyboard


let g:startify_bookmarks = [
      \ {'c': '~/.config/nvim/init.vim'},
      \ '~/Programming/Koreny/laptiming-frontend',
      \ '~/Programming/Koreny/casomira-backend',
      \]
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:ascii = [
      \ '        __                   ______                         ',
      \ '       / /   ____  _________/ / __ \__  ______ ___  ____ _  ',
      \ '      / /   / __ \/ ___/ __  / /_/ / / / / __ `__ \/ __ `/  ',
      \ '     / /___/ /_/ / /  / /_/ / ____/ /_/ / / / / / / /_/ /   ',
      \ '    /_____/\____/_/   \__,_/_/    \__,_/_/ /_/ /_/\__,_/    ',
      \]
let g:startify_custom_header = g:ascii
let g:startify_enable_special = 0

let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }
let g:diagnostic_enable_virtual_text = 1
call sign_define("LspDiagnosticsErrorSign", {"text" : "❌", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "⚠", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticInformationSign", {"text" : "ℹ", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticHintSign", {"text" : "🤔", "texthl" : "LspDiagnosticsHint"})

autocmd FileType php setlocal sw=4 sts=4 ts=4 et
autocmd BufNewFile,BufRead *.php syntax enable
set guifont=JetBrainsMono\ nl:h18
hi Normal guibg=NONE ctermbg=NONE
