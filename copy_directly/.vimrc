" ==== Plugins ====
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'tpope/vim-commentary'
Plug 'iaalm/terminal-drawer.vim'

call plug#end() " end plugins

" ==== Color Scheme ====
set termguicolors
colorscheme catppuccin_mocha

" ==== LSP ====
filetype plugin on

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>l <plug>(lsp-document-diagnostics)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled (set the lsp shortcuts) when an lsp server
    " is registered for a buffer.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" ==== Comments ====
filetype indent on
autocmd FileType cpp setlocal commentstring=//\ %s

" ==== Autocomplete ====
let g:asyncomplete_auto_popup = 0

inoremap <expr><C-j> pumvisible() ? "\<C-n>" : asyncomplete#force_refresh()
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : asyncomplete#force_refresh()
inoremap <expr><TAB> pumvisible() ? "\<C-y>" : "<TAB>"

" ==== General Options =====
" Line numbers
set number
set relativenumber

" Gutter
set numberwidth=4
set signcolumn=yes

" Friendship ended with tabs. Now spaces are my best friend.
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Persistent undo
set undofile

" Update time... idk why this would be set to anything higher
set updatetime=50

" Ignore case when searching lowercase only
set ignorecase
set smartcase

" Incremental search
set incsearch

" Highlight from search
set hlsearch

" Show line at 80 columns
set colorcolumn=80

" Show line of cursor
set cursorline

" Wrapping is not nice
set nowrap

" 8 lines/columns around the cursor at all times
set scrolloff=8
set sidescrolloff=8

" Undo/backup/swap files directories
if !isdirectory(expand('~/.vim/backup'))
    call mkdir(expand('~/.vim/backup'), 'p')
endif
if !isdirectory(expand('~/.vim/swap'))
    call mkdir(expand('~/.vim/swap'), 'p')
endif
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p')
endif
set backupdir=~/.vim/backup/
set directory=~/.vim/swap/
set undodir=~/.vim/undo/

" ==== Keybinds ====
" Space as leader character
let mapleader=" "

" Delete/yank all text
nnoremap <leader>d% :%d<CR>
nnoremap <leader>y% :%y+<CR>

" Inverse tab
inoremap <S-Tab> <C-d>

" Keep cursor in place when using J
nnoremap J mzJ`z

" Keep cursor centered when half-page jumping
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep cursor centered when navigating search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Better paste in visual mode
vnoremap p "_dP

" Copy to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Indentation
vnoremap < <gv
vnoremap > >gv

" Enter insert mode in the terminal
tnoremap <Esc> <C-\><C-n>

" Append/insert should match indentation level
function! MatchLine(action)
    let line = getline('.')
    if empty(line) || line =~ '^\s\+$'
        return "cc"
    else
        return a:action
    endif
endfunction

" Improved insert/append
nnoremap <expr> i MatchLine("i")
nnoremap <expr> a MatchLine("a")

" Netrw
nnoremap <leader>nf :Ex<CR>
let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro"

" Remove highlight
nnoremap <C-l> :noh<CR>

