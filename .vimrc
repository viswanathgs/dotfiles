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
Plug 'jlfwong/vim-mercenary'  " Like vim-fugitive but for hg
Plug 'sbdchd/neoformat'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'fs111/pydoc.vim'  " Python documentation (Shift+K for word under cursor)
Plug 'godlygeek/tabular'  " Dependency for vim-markdown
Plug 'plasticboy/vim-markdown'  " Markdown folds
Plug 'dkarter/bullets.vim'  " Auto lists and checkboxes/todo-lists
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
set background=dark
colorscheme desert

" Scrolling
set scrolljump=5                " Scroll five lines at a time vertically
set sidescroll=10               " Minumum columns to scroll horizontally

" Search
set hlsearch                    " Highlight search hits
set incsearch                   " Enable incremental search
set ignorecase                  " Case-insensitive search

" Misc
set noerrorbells                " No bells in terminal
set backspace=indent,eol,start  " Backspace over everything
set tags=tags;/                 " Search up the directory tree for tags
set undolevels=1000             " Number of undos stored
set viminfo='50,"50             " '=marks for x files, "=registers for x files
set shortmess+=a                " Abbreviated error messages
set shortmess+=A                " Ignore warning when .swp file exists
set clipboard=unnamed           " Use system clipboard


""""""""""""""""""""""""""""""""""""""""""
" Filetype plugins
""""""""""""""""""""""""""""""""""""""""""

filetype indent plugin on
syntax enable

augroup additional_filetypes
  autocmd!
  autocmd BufNewFile,BufRead *.cuh set filetype=cuda
  autocmd BufNewFile,BufRead TARGETS set filetype=python
augroup END


""""""""""""""""""""""""""""""""""""""""""
" Util functions and custom commands
""""""""""""""""""""""""""""""""""""""""""

" Like windo but restore the current window.
" https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers.
function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction
command! -nargs=+ -complete=command Windo call WinDo(<q-args>)


" Like bufdo but restore the current buffer.
" https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers.
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
command! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)


" Like tabdo but restore the current tab.
" https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers.
function! TabDo(command)
  let currTab=tabpagenr()
  execute 'tabdo ' . a:command
  execute 'tabn ' . currTab
endfunction
command! -nargs=+ -complete=command Tabdo call TabDo(<q-args>)


" Return the previously searched string from the search register '/'. Could be
" used as an argument to fzf :Rg for instance (see mapping for <leader>s).
" Taken from ack.vim ack#AckFromSearch() - https://github.com/mileszs/ack.vim/blob/master/autoload/ack.vim
function! GetSearchRegister()
  " Get the last search term from the register '/'
  let search = getreg('/')
  " Translate vim regex to perl regex
  let search = substitute(search, '\(\\<\|\\>\)', '\\b', 'g')
  return search
endfunction


" Clear the search register '/' to remove the last search term.
" See mapping for <leader>/ and associated comments.
function! ClearSearchRegister()
  call setreg('/', [])
endfunction


" Set pdb trace
function! InsertPdb()
  let trace = expand("import pdb; pdb.set_trace() # yapf: disable TODO slog")
  execute "normal o".trace
endfunction


" Print phabricator URL for the current file. Works both in normal mode
" as well as with range selection in visual mode.
" TODO: make this universal - work with :GBrowse
function! GetPhabricatorURL() range
  " Get current filename and any highlighted line number or range
  let filename = expand( "%:f" )
  let lineno = line('.')
  if a:lastline - a:firstline > 0
      let lineno = a:firstline . "-" . a:lastline
  endif
  " Get phabricator url via diffusion command and print
  let url = trim(system("diffusion " . filename . ":" . lineno))
  " Put the url in clipboard so it can be pasted into chrome
  call setreg('+', url)
  " Print the url
  echom url
endfunction


" Replace a line of space-separated text into individual lines
function! SplitToLines() range
  for lnum in range(a:lastline, a:firstline, -1)
    let words = split(getline(lnum))
    execute lnum . "delete"
    call append(lnum-1, words)
  endfor
endfunction

" Kill any trailing whitespace
function! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction


""""""""""""""""""""""""""""""""""""""""""
" Custom Keymaps
""""""""""""""""""""""""""""""""""""""""""

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


" Vim folds
" Default fold commands start with z. Remap to f to avoid Emacs pinky.
map fo zo      " Open fold under cursor
map fO zO      " Open fold under cursor (recursive)
map fc zc      " Close fold under cursor
map fC zC      " Close fold under cursor (recursive)
map ft za      " Toggle fold under cursor
map fT zA      " Toggle fold under cursor (recursive)
map fl zm      " Show less - fold one level more
map fL zM      " Fold all
map fm zr      " Show more - unfold one more level
map fM zR      " Show/unfold all
map ff zM zv   " Focus - fold all but the one under cursor
map fgg [z     " Move to the start of the current fold
map fG ]z      " Move to the end of the current fold
map fj zj      " Move to the start of the next fold
map fk zk      " Move to the end of the previous fold


" Avoid jumping to the next match when using * to highlight word under the cursor.
" https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump
nnoremap * *``
nnoremap * :keepjumps normal! mi*`i<CR>


" Set pdb trace on <leader>b for python files
augroup pdb
  autocmd!
  autocmd FileType python map <leader>b :call InsertPdb()<CR>
augroup END

" Map <leader>l to print phabricator URL for current file. Works with visual
" ranges too.
map <leader>l :call GetPhabricatorURL()<CR>


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
augroup nerdtree
  autocmd!
  " Focus cursor in new document on startup
  autocmd VimEnter * wincmd p
  " Close vim if the only window left open is a NERDTree
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  " Auto-create a NERDTree mirror in every vim tab (filtering out quickfix)
  autocmd BufWinEnter * if &buftype != 'quickfix' | NERDTreeMirror | endif
  " Uncomment to open NERDTree automatically when vim starts up
  " autocmd VimEnter * NERDTree
augroup END


" fzf.vim
" Keymaps to open files in splits from fzf window
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
" <leader>f to search filenames (using fd if available)
nnoremap <leader>f :Files<CR>
" <leader>s to search file contents (uses ripgrep underneath)
nnoremap <leader>s :Rg <C-R>=GetSearchRegister()<CR>
" Map <leader>/ to clear the search register '/'. This avoids needing to type
" /asdf to clear search highlight. More importantly, we rely on this register
" to get the last search term to pass into fzf :Rg command (see mapping for
" <leader>s). We need a mechanism to clear this so that <leader>s outputs
" ':Rg ' (instead of ':Rg asdf') to be able to enter a fresh search term.
" Also do this automatically when vim starts up.
nnoremap <silent> <leader>/ :call ClearSearchRegister()<CR>
augroup fzf
  autocmd!
  autocmd VimEnter * :call ClearSearchRegister()
augroup END
" <leader>gs for git status and list modified files in fzf in the current repo.
" Also display diff for each modified file in fzf preview.
nnoremap <leader>gs :GFiles?<CR>
" <leader>gll to show git log for the current repo in fzf.
" Also display commit diff in fzf preview.
nnoremap <leader>gll :Commits<CR>
" <leader>gl. to show git log for the current file in fzf.
" Also display each commit diff in fzf preview.
nnoremap <leader>gl. :BCommits<CR>
" <leader>w to list open files in vim tabs and windows and quickly switch
nnoremap <leader>w :Windows<CR>


" pydoc.vim - https://github.com/fs111/pydoc.vim/blob/master/ftplugin/python_pydoc.vim
let g:pydoc_window_lines=0.3 " 30% of current window


" vim-fugitive, vim-rhubarb, vim-mercenary
map <leader>gh :GBrowse<CR>
map <leader>gb :Git blame<CR>
map <leader>hb :HGblame<CR>


" vim-markdown - https://github.com/plasticboy/vim-markdown
set conceallevel=2
let g:vim_markdown_new_list_item_indent = 0  " Number of indent spaces on new list item
let g:vim_markdown_toc_autofit = 1  " Autofit Table of Contents (ToC) window
let g:vim_markdown_math = 1  " LaTeX extension on
let g:vim_markdown_conceal_code_blocks = 0  " Don't conceal code-blocks
augroup vim_markdown_folds
  autocmd!
  autocmd FileType markdown map fj <Plug>Markdown_MoveToNextHeader
  autocmd FileType markdown map fk <Plug>Markdown_MoveToPreviousHeader
  autocmd FileType markdown map fJ <Plug>Markdown_MoveToNextSiblingHeader
  autocmd FileType markdown map fK <Plug>Markdown_MoveToPreviousSiblingHeader
  autocmd FileType markdown map fu <Plug>Markdown_MoveToParentHeader
  autocmd FileType markdown map fi :Toc<CR>  " Show Table of Contents
  autocmd FileType markdown map f> :HeaderIncrease<CR>  " Increase level of all or selected headers
  autocmd FileType markdown map f< :HeaderDecrease<CR>  " Decrease level of all or selected headers
augroup NED


" bullets.vim - https://github.com/dkarter/bullets.vim
let g:bullets_nested_checkboxes = 0  " Decouple parent and child checkbox toggling


" neoformat
" Define ufmt command for neoformat to execute
let g:neoformat_python_ufmt = {
  \ 'exe': 'ufmt',
  \ 'args': ['format'],
  \ 'replace': 1,
  \ }
" Python formatters for neoformat to try in order of priority
let g:neoformat_enabled_python = ['ufmt', 'black']


""""""""""""""""""""""""""""""""""""""""""
" Lint
""""""""""""""""""""""""""""""""""""""""""

augroup lint_and_format
  autocmd!

  " Neoformat
  " CTRL-F to format
  autocmd FileType python map <C-f> :Neoformat<CR>
  autocmd FileType python imap <C-f> <ESC>:Neoformat<CR>i
  " Autoformat on save
  " autocmd FileType python autocmd BufWritePre * Neoformat

  " Clang-format. TODO: just use NeoFormat?
  autocmd FileType c,cpp,cc,cuda,java,objc,proto map <C-f> :ClangFormat<CR>
  autocmd FileType c,cpp,cc,cuda,java,objc,proto imap <C-f> <ESC>:ClangFormat<CR>i
  " Uncomment below to auto-format on buffer write
  " autocmd FileType c,cpp,cc,cuda,java,objc,proto ClangFormatAutoEnable

  " Strip any training whitespace on buffer write
  autocmd FileType c,cabal,cpp,cuda,python,haskell,erlang,javascript,php,ruby,readme,tex,text,thrift
    \ autocmd BufWritePre <buffer>
    \ :call <SID>StripTrailingWhitespaces()

  " Highlight past 79 characters
  " highlight CharLimit ctermbg=black ctermfg=white guibg=#592929
  " autocmd FileType c,cabal,cpp,cuda,python,haskell,erlang,javascript,php,ruby,thrift
  " \ match CharLimit /\%80v.\+/
augroup END
