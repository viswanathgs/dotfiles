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
Plug 'sbdchd/neoformat'
Plug 'mileszs/ack.vim'
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
" Custom Keymaps
""""""""""""""""""""""""""""""""""""""""""

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
" Reload all windows in the current tab
nnoremap we  :windo e<CR>

""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
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
" Don't auto-open the first result
nnoremap <leader>a :Ack!<Space>
cnoreabbrev Ack Ack!
" Split rightward so as not to displace a left NERDTree
let g:ack_mappings = {
  \  'v': '<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p',
  \ 'gv': '<C-W><CR><C-W>L<C-W>p<C-W>J' }

""""""""""""""""""""""""""""""""""""""""""
" Lint
""""""""""""""""""""""""""""""""""""""""""

" Highlight past 80 characters
highlight CharLimit ctermbg=black ctermfg=white guibg=#592929
autocmd FileType c,cabal,cpp,cuda,python,haskell,erlang,javascript,php,ruby,thrift
  \ match CharLimit /\%81v.\+/

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
