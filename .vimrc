" .vimrc

" Load FB-specific stuff
if filereadable(glob("~/.fb.vimrc"))
  source ~/.fb.vimrc
endif

" vim-plug.
" To install, run `:PlugInstall` and then `:PlugUpdate`.
" To remove, run `:PlugClean`.
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'rhysd/vim-clang-format'
Plug 'tpope/vim-fugitive'  " Git wrapper
Plug 'tpope/vim-rhubarb'  " Github extension for vim-fugitive (:GBrowse)
Plug 'sbdchd/neoformat'
Plug 'mileszs/ack.vim'  " Search in directory (for word under cursor)
Plug 'fs111/pydoc.vim'  " Python documentation (Shift+K for word under cursor)
call plug#end()

set nocompatible
let mapleader=","

" Splits
set splitbelow
set splitright

" Indent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent                  " Carry indent over to new lines

" Display
set cursorline                  " Highlight current line
set ruler                       " Show cursor position
set nonumber                    " Hide line numbers
set nolist                      " Hide tabs and EOL chars
set showcmd                     " Show normal mode commands as they are entered
set showmode                    " Show editing mode in status (-- INSERT --)
set showmatch                   " Flash matching delimiters
set background=light

" Scrolling
set scrolljump=5                " Scroll five lines at a time vertically
set sidescroll=10               " Minumum columns to scroll horizontally

" Search
set hlsearch                    " Highlight search hits
set incsearch                   " Enable incremental search
set ignorecase                  " Ignore case in search

" Misc
set noerrorbells                " No bells in terminal
set backspace=indent,eol,start  " Backspace over everything
set tags=tags;/                 " Search up the directory tree for tags
set undolevels=1000             " Number of undos stored
set viminfo='50,"50             " '=marks for x files, "=registers for x files
set shortmess+=A                " Ignore warning when .swp file exists
set clipboard=unnamed           " Use system clipboard

""""""""""""""""""""""""""""""""""""""""""
" Filetype plugins
""""""""""""""""""""""""""""""""""""""""""

" Vim defaults to `filetype on`, and unless we toggle it, 
" custom filetype detections won't be run.
filetype off
filetype indent plugin on
syntax enable

" Extensions
autocmd BufNewFile,BufRead *.cuh set filetype=cuda

""""""""""""""""""""""""""""""""""""""""""
" Custom commands
""""""""""""""""""""""""""""""""""""""""""

" Like windo but restore the current window.
" https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers.
function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction
com! -nargs=+ -complete=command Windo call WinDo(<q-args>)

" Like bufdo but restore the current buffer.
" https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers.
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
com! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

" Like tabdo but restore the current tab.
" https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers.
function! TabDo(command)
  let currTab=tabpagenr()
  execute 'tabdo ' . a:command
  execute 'tabn ' . currTab
endfunction
com! -nargs=+ -complete=command Tabdo call TabDo(<q-args>)

""""""""""""""""""""""""""""""""""""""""""
" Custom Keymaps
""""""""""""""""""""""""""""""""""""""""""

" Avoid the escape
inoremap jj <ESC>

" Vim tabs
nnoremap tn  :tabnew<CR>
nnoremap td  :tabclose<CR>
nnoremap th  :tabprev<CR>
nnoremap tl  :tabnext<CR>
nnoremap tg  :tabfirst<CR>
nnoremap te  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tm  :tabmove<Space>
nnoremap ts  :tabs

" Vim windows
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
" Move to the first / leftmost window
nnoremap <C-g> <C-w>1w
" Move to the last / rightmost window
nnoremap <C-e> <C-w>100w
" Reload all tabs. We use our custom `Tabdo` instead of `tabdo` 
" to restore the current tab and window, and `silent!` to suppress
" errors related to quickfix and nerdtree buffers. To only reload
" windows within the current tab, use `Windo`.
" https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers.
nnoremap <leader>r :silent! Tabdo e<CR>

" Set pdb trace on <leader>b
map <Leader>b :call InsertPdb()<CR>
function! InsertPdb()
  let trace = expand("import pdb; pdb.set_trace() # yapf: disable TODO slog")
  execute "normal o".trace
endfunction

""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
" Remap some keys for consistency between plugins
let g:NERDTreeMapOpenVSplit = 'v'  " Vertical split
let g:NERDTreeMapPreviewVSplit = 'gv'  " Vertical split (maintain focus in NERDTree)
let g:NERDTreeMapOpenSplit = 's'  " Horizontal split
let g:NERDTreeMapPreviewSplit = 'gs'  " Horizontal split (maintain focus in NERDTree)
" Change vim CWD together with NERDTree's root dir
let g:NERDTreeChDirMode = 2
" Uncomment to open NERDTree automatically when vim starts up
" autocmd VimEnter * NERDTree
" Focus cursor in new document on startup
autocmd VimEnter * wincmd p
" Close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Auto-create a NERDTree mirror in every vim tab. Filter out quickfix window
" though to avoid conflicts with ack.vim.
autocmd BufWinEnter * if &buftype != 'quickfix' | NERDTreeMirror | endif

" ack.vim - https://github.com/mileszs/ack.vim
" Use ag with ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" Keymaps
nnoremap <leader>s :Ack!<Space>
nnoremap <leader>f :AckFile!<Space>
" Don't auto-open the first result
cnoreabbrev Ack Ack!
cnoreabbrev AckFile AckFile!
" Split rightward so as not to displace a left NERDTree
let g:ack_mappings = {
  \  'v': '<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p',
  \ 'gv': '<C-W><CR><C-W>L<C-W>p<C-W>J' }

" pydoc.vim - https://github.com/fs111/pydoc.vim/blob/master/ftplugin/python_pydoc.vim
let g:pydoc_window_lines=0.3 " 30% of current window

" vim-fugitive and vim-rhubarb
map <leader>gh :GBrowse<CR>
map <leader>gb :Git blame<CR>

""""""""""""""""""""""""""""""""""""""""""
" Lint
""""""""""""""""""""""""""""""""""""""""""

" Highlight past 79 characters
highlight CharLimit ctermbg=black ctermfg=white guibg=#592929
autocmd FileType c,cabal,cpp,cuda,python,haskell,erlang,javascript,php,ruby,thrift
  \ match CharLimit /\%80v.\+/

" Kill any trailing whitespace on save
fu! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfu
autocmd FileType c,cabal,cpp,cuda,python,haskell,erlang,javascript,php,ruby,readme,tex,text,thrift
  \ autocmd BufWritePre <buffer>
  \ :call <SID>StripTrailingWhitespaces()

" Clang-format
map <C-f> :ClangFormat<CR>
imap <C-f> <ESC>:ClangFormat<CR>i
" Uncomment below to auto-format
" autocmd FileType c,cpp,cc,cuda,java,objc,proto ClangFormatAutoEnable

" yapf
autocmd FileType python map <C-f> :Neoformat<CR>
autocmd FileType python imap <C-f> <ESC>:Neoformat<CR>i
" Autoformat on save
autocmd BufWritePre *.py Neoformat

""""""""""""""""""""""""""""""""""""""""""
" Util functions
""""""""""""""""""""""""""""""""""""""""""

" Replace a line of space-separated text into individual lines
function SplitToLines() range
  for lnum in range(a:lastline, a:firstline, -1)
    let words = split(getline(lnum))
    execute lnum . "delete"
    call append(lnum-1, words)
  endfor
endfunction
