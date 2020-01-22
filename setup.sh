#!/usr/bin/env bash

# Update submodules
git submodule update --init --recursive --remote

# Setup symlinks to homedir
for f in $(ls -a | grep '^\.')
do
  if ! [[ ($f == .)  || ($f == ..) || ($f =~ .git*) ]]
  then
    echo "Symlink: ~/$f -> $(pwd)/$f"
    ln -sf $(pwd)/$f ~/$f
  fi
done

# Install deps
brew install clang-format || true

echo "Done setting up dotfiles!"
