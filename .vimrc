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
nnoremap tn  :tabnew<CR>      " New tab
nnoremap td  :tabclose<CR>    " Close the current tab
nnoremap th  :tabfirst<CR>    " Switch to the first tab
nnoremap tl  :tablast<CR>     " Switch to the last tab
nnoremap tj  :tabnext<CR>     " Switch to the next tab
nnoremap tk  :tabprev<CR>     " Switch to the previous tab
nnoremap tt  :tabedit<Space>  " Edit the specified file in a new tab
nnoremap tm  :tabmove<Space>  " Move current tab to the specified position
nnoremap te  :tabdo e<CR>     " Reload all tabs
nnoremap ts  :tabs            " Show all tabs including their windows

" Vim windows
nnoremap we  :windo e<CR>     " Reload all windows in the current tab

" Clang-format
map <C-K> :pyf ~/.vim/bin/clang-format.py<CR>
imap <C-K> <ESC>:pyf ~/.vim/bin/clang-format.py<CR>i

""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""

" NERDTree
map <leader>nt :NERDTreeToggle<CR>
" Open a NERDTree automatically when vim starts up
autocmd VimEnter * NERDTree
" Focus cursor in new document on startup
autocmd VimEnter * wincmd p
" Close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Auto-create a NERDTree mirror in every vim tab
autocmd BufWinEnter * NERDTreeMirror

""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""

" Highlighting text past 80 characters
highlight CharLimit ctermbg=black ctermfg=white guibg=#592929
match CharLimit /\%81v.\+/

" Kill any trailing whitespace on save
fu! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfu
autocmd FileType c,cabal,cpp,python,haskell,erlang,javascript,php,ruby,readme,tex,text,thrift
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
