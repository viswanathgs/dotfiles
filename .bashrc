# .bashrc

# Aliases
alias sudo='sudo '
alias v='vim'
alias ca='conda activate'
alias cda='conda deactivate'

# Default editor to vim
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

# Bash history
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

# Util functions
function find_and_replace() {
  find_str=$1
  replace_str=$2
  file_pattern=$3
  find . -type f -name "$file_pattern" -exec sed -i '' "s/$find_str/$replace_str/g" {} \;
}

function find_and_delete() {
  find_str=$1
  file_pattern=$2
  find . -type f -name "$file_pattern" -exec sed -i '' "/$find_str/d" {} \;
}

# Hg specific
rebase() {
  hg pull
  hg update $1
  hg rebase -d master
}
alias dif='hg diff'
alias commit='hg commit'
alias amend='hg commit --amend'

shopt -s checkwinsize

# Git autocompletion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Load FB-specific stuff
if [ -f ~/.fb.bashrc ]; then
	source ~/.fb.bashrc
fi
