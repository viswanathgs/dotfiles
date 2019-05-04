" .vimrc

" Load FB-specific stuff
if filereadable(glob("~/.fb.vimrc"))
  source ~/.fb.vimrc
endif

" Pathogen. Load installed plugins in ~/.vim/bundle.
execute pathogen#infect()

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

" Clang-format
map <C-I> :pyf ~/.vim/bin/clang-format.py<CR>
imap <C-I> <ESC>:pyf ~/.vim/bin/clang-format.py<CR>i

""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""

" NERDTree
map <leader>nt :NERDTreeToggle<CR>
" Uncomment to open a NERDTree automatically when vim starts up
" autocmd VimEnter * NERDTree
" Focus cursor in new document on startup
autocmd VimEnter * wincmd p
" Close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Auto-create a NERDTree mirror in every vim tab
autocmd BufWinEnter * NERDTreeMirror

""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""

" Extensions
autocmd BufNewFile,BufRead *.cuh set filetype=cuda

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
