" TODO: eventually migrate to init.lua after lua-ifying vimrc
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Import lua modules
:lua require("options")
