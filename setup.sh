#!/usr/bin/env zsh -e

# Requirements: iterm2 and zsh, homebrew, python3, python-pip
# Set zsh as default: chsh -s /bin/zsh

MAC_DEPS=(
  tmux
  bat           # cat++
  exa           # ls++
  fd            # find++
  neovim        # vim++
  ripgrep       # grep++
  fzf           # fuzzy finder - https://github.com/junegunn/fzf
  tree          # for fzf previews of dir trees
  git-delta     # improved diff viz - https://github.com/dandavison/delta
  clang-format
  gh
  openssl
  wget
  reattach-to-user-namespace  # tmux access to clipboard: https://blog.carbonfive.com/copying-and-pasting-with-tmux-2-4
)

BIN_DIR=~/bin

function brewIn() {
  if brew ls --versions "$1"; then
    brew upgrade "$1"
  else
    brew install "$1"
  fi
}

function install_deps() {
  echo "\n#### Installing brew dependencies ####\n"
  brew update || true
  for dep in ${MAC_DEPS}; do
    brewIn ${dep} || true
  done
  $(brew --prefix)/opt/fzf/install --all || true  # fzf key-bindings and fuzzy completion

  echo "\n#### Installing pip dependencies ####\n"
  pip install --upgrade pre-commit tabcompletion cpplint ptpython pdbpp || true

  echo "\n#### Installing on-my-zsh ####\n"
  # Install oh-my-zsh into current dir. We'll symlink later to homedir.
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | ZSH=.oh-my-zsh sh || true

  echo "\n#### Installing antigen ####\n"
  # Install antigen (for easier third-party plugin management than oh-my-zsh) into current dir.
  # We'll symlink later to homedir.
  curl -L git.io/antigen > .antigen.zsh
}

function symlink_dotfiles() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: ${0} <target_dir>"
    return
  fi

  echo "\n#### Setting up symlinks ####\n"

  target_dir="${1}"

  # Symlink dotfiles to target_dir
  for f in $(ls -a | grep '^\.'); do
    if ! [[ ($f == .)  || ($f == ..) || ($f =~ "^\.git.*") || ($f =~ "\.sw.*") ]]; then
      echo "Symlink: ${target_dir}/${f} -> $(pwd)/${f}"
      ln -sf $(pwd)/${f} ${target_dir}/
    fi
  done
}

function download_binary() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: ${0} <release_url.tar.gz> [<num_leading_path_elements_to_skip>]"
    return
  fi

  url="${1}"
  strip_components="${2:-0}"

  echo "Extracting ${url} to ${BIN_DIR}"
  mkdir -p ${BIN_DIR}
  wget -qO- ${url} | tar xz - -C ${BIN_DIR}/ --strip-components=${strip_components}
}

git submodule update --init --recursive --remote
install_deps
symlink_dotfiles ~  # Symlink dotfiles to homedir
git config --global include.path ~/.delta.gitconfig  # git-delta config

echo "\n#### Done setting up dotfiles! ####\n"
