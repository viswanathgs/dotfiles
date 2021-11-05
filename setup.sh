#!/usr/bin/env zsh

# Requirements: iterm2 and zsh, homebrew, python-pip
# Set zsh as default: chsh -s /bin/zsh

# Update submodules
git submodule update --init --recursive --remote

function brewIn() {
  if brew ls --versions "$1"; then
    brew upgrade "$1"
  else
    brew install "$1"
  fi
}

# Install deps
pip install --upgrade yapf black pre-commit tabcompletion cpplint ptpython pdbpp || true
brewIn clang-format || true
brewIn the_silver_searcher || true
brewIn hub || true
# For tmux to access clipboard: https://blog.carbonfive.com/copying-and-pasting-with-tmux-2-4/
brewIn reattach-to-user-namespace || true

# Install oh-my-zsh into current dir. We'll symlink later to homedir.
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | ZSH=.oh-my-zsh sh

# Install antigen (for easier third-party plugin management than oh-my-zsh) into current dir.
# We'll symlink later to homedir.
curl -L git.io/antigen > .antigen.zsh

# Setup symlinks to homedir and to ~/.ondemand/homedir (for ondemand dot-file sync)
ONDEMAND_HOMEDIR=~/.ondemand/homedir
mkdir -p "${ONDEMAND_HOMEDIR}"
for f in $(ls -a | grep '^\.')
do
  if ! [[ ($f == .)  || ($f == ..) || ($f =~ "\.git.*") || ($f =~ "\.sw.*") ]]; then
    echo "Symlink: ~/$f -> $(pwd)/$f"
    ln -sF $(pwd)/$f ~/  # homedir
    ln -sF $(pwd)/$f "${ONDEMAND_HOMEDIR}"/  # ondemand homedir
  fi
done

echo "Done setting up dotfiles!"
