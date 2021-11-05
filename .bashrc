# .bashrc

# Required for ondemand dot-file sync and switching to zsh

# bashrc is for aliases, functions, and shell configuration intended for use in
# interactive shells.  However, in some circumstances, bash sources bashrc even
# in non-interactive shells (e.g., when using scp), so it is standard practice
# to check for interactivity at the top of .bashrc and return immediately if
# the shell is not interactive.  The following line does that; don't remove it!
[[ $- != *i* ]] && return

# Load CentOS stuff and Facebook stuff (don't remove these lines).
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi
if [ -f /usr/facebook/ops/rc/master.bashrc ]; then
  source /usr/facebook/ops/rc/master.bashrc
fi

# Keep oodles of command history (see https://fburl.com/bashhistory).
HISTFILESIZE=-1
HISTSIZE=1000000
shopt -s histappend

# Switch to zsh finally
zsh; exit "$?"
