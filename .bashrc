# .bashrc

# Aliases
alias sudo='sudo '
alias v='vim'

# Default editor to vim
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

# bash history
HISTSIZE=130000 HISTFILESIZE=-1

# Terminal prompt
function parse_git_branch {
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
}
function parse_hg_branch {
  hg bookmarks 2> /dev/null | sed -e '/^\s\+[^*]/d' -e 's/\s\+\* \(\S\+\).*/(\1)/'
}
function parse_branch {
  echo $(parse_git_branch) $(parse_hg_branch)
}
function prompt {
  local WHITE="\[\033[1;37m\]"
  local GREEN="\[\033[0;32m\]"
  local CYAN="\[\033[0;36m\]"
  local GRAY="\[\033[0;37m\]"
  local BLUE="\[\033[0;34m\]"
  export PS1="${GREEN}\u${CYAN}@${BLUE}\h ${CYAN}\w"' $(parse_branch)'" ${GRAY}"
}
prompt
