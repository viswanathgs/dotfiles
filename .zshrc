# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc

export PATH=$PATH:$HOME/bin:$HOME/.local/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()  # Ignore, taken over by antigen below

source $ZSH/oh-my-zsh.sh

###################################################
#
# Antigen
#
###################################################

# Antigen for easier plugin and theme management than oh-my-zsh/custom
source ~/.antigen.zsh
antigen use oh-my-zsh

# Theme
# antigen theme jreese
#
# The following two must be enabled together:
# antigen bundle mafredri/zsh-async
# antigen bundle sindresorhus/pure
#
antigen theme romkatv/powerlevel10k

# Plugins from oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
antigen bundle git
antigen bundle colored-man-pages
antigen bundle web-search
antigen bundle vi-mode

# Custom/third-party plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Plugin settings
## zsh-autosuggestions (prefer tab completion suggestions first and then history)
# export ZSH_AUTOSUGGEST_STRATEGY=(completion history)

# Apply
antigen apply

###################################################
#
# User configuration
#
###################################################

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
export HISTSIZE=130000
export HISTFILESIZE=-1
export PYTHONSTARTUP="$HOME/.pythonrc"

# Aliases
alias woman='man'  # For Silky
alias sudo='sudo '
alias v='vim'
## git
alias gco='git checkout'
alias gd='git diff'
alias gc='git commit -a -v'
alias ga='git commit -a -v --amend'
alias gs='git status'
alias gst='git stash'
alias gb='git branch -vv'
alias gl='git log --graph --decorate --oneline'
alias gpr='git pull --rebase'
alias gprom='git pull --rebase origin master'
alias gprum='git pull --rebase upstream master'
## hg
alias hd='hg diff'
alias hc='hg commit'
alias ha='hg commit --amend'
alias hb='hg bookmarks'
function hp() {
  hg pull
  hg update $1
  hg rebase -d master
}
## Conda
alias ca='conda activate'
alias cda='conda deactivate'
alias cenv='conda env'
## Buck
alias bb='buck build'
alias bt='buck test'
alias br='buck run'
alias bbmd='bb @mode/mac/dev-release'
alias bbld='bb @mode/linux/dev-release'
alias btmd='bt @mode/mac/dev-release'
alias btld='bt @mode/linux/dev-release'
alias brmd='br @mode/mac/dev-release'
alias brld='br @mode/linux/dev-release'
## aws
alias s3ls='aws s3 ls --summarize --human-readable --recursive'
alias s3cp='aws s3 cp'
alias s3put='aws s3api put-object' # s3put --bucket <bucket> --key <path>
## Misc
alias goog='google' # from web-search plugin

# Util functions

## Find and replace with ag and sed
function agr() {
  # find and replace
  regex=s/${1}/${2}/g;
  ag $1 -l | xargs sed -i.agr_backup $regex;
  # delete backups
  ag -G .agr_backup -l | xargs rm
}

## Find and delete with ag and sed
function agd() {
  # find and delete
  regex=/${1}/d;
  ag $1 -l | xargs sed -i.agd_backup $regex;
  # delete backups
  ag -G .agd_backup -l | xargs rm
}

## List all files containing specified extensions.
## Example: lsext cpp cc h
function lsext() {
  pattern=""
  for i in "$@"; do
    if [ ! -z "$pattern" ]; then
      pattern+="|"
    fi
    pattern+="$i"
  done

  ag -g ".*\.(${pattern})$"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/viswanath/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/viswanath/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/viswanath/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/viswanath/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Load FB-specific stuff
if [ -f ~/.fb.zshrc ]; then
	source ~/.fb.zshrc
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
