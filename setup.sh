#!/usr/bin/env zsh

# Requirements: iterm2 and zsh, homebrew, python-pip
# Set zsh as default: chsh -s /bin/zsh

MAC_DEPS=(
  bat           # cat++
  exa           # ls++
  fd            # find++
  ripgrep       # grep++
  fzf           # fuzzy finder - https://github.com/junegunn/fzf
  tree          # for fzf previews of dir trees
  git-delta     # improved diff viz - https://github.com/dandavison/delta
  clang-format
  hub
  openssl
  wget
  reattach-to-user-namespace  # tmux access to clipboard: https://blog.carbonfive.com/copying-and-pasting-with-tmux-2-4
)

# FB dev
ONDEMAND_HOMEDIR=~/.ondemand/homedir
ONDEMAND_BIN_DIR=${ONDEMAND_HOMEDIR}/bin

function brewIn() {
  if brew ls --versions "$1"; then
    brew upgrade "$1"
  else
    brew install "$1"
  fi
}

function install_deps() {
  pip install --upgrade pre-commit tabcompletion cpplint ptpython pdbpp || true

  brew update || true
  for dep in ${MAC_DEPS}; do
    brewIn ${dep} || true
  done
  $(brew --prefix)/opt/fzf/install || true  # fzf key-bindings and fuzzy completion

  # Install oh-my-zsh into current dir. We'll symlink later to homedir.
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | ZSH=.oh-my-zsh sh

  # Install antigen (for easier third-party plugin management than oh-my-zsh) into current dir.
  # We'll symlink later to homedir.
  curl -L git.io/antigen > .antigen.zsh
}

function symlink_dotfiles() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: ${0} <target_dir>"
    return
  fi

  target_dir="${1}"

  # Symlink dotfiles to target_dir
  for f in $(ls -a | grep '^\.'); do
    if ! [[ ($f == .)  || ($f == ..) || ($f =~ "^\.git.*") || ($f =~ "\.sw.*") ]]; then
      echo "Symlink: ${target_dir}/${f} -> $(pwd)/${f}"
      ln -sF $(pwd)/${f} ${target_dir}/
    fi
  done
}

function download_binary_for_ondemand() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: ${0} <release_url.tar.gz> [<num_leading_path_elements_to_skip>]"
    return
  fi

  url="${1}"
  strip_components="${2:-0}"

  echo "Extracting ${url} to ${ONDEMAND_BIN_DIR}"
  mkdir -p ${ONDEMAND_BIN_DIR}
  wget -qO- ${url} | tar xz - -C ${ONDEMAND_BIN_DIR}/ --strip-components=${strip_components}
}

function fb_dev_setup() {
  # Symlink dotfiles to ~/.ondemand/homedir for ondemand dot-file sync
  echo "Symlinking dotfiles to ${ONDEMAND_HOMEDIR}"
  mkdir -p ${ONDEMAND_HOMEDIR}
  symlink_dotfiles ${ONDEMAND_HOMEDIR}

  # Download fzf binary and put it in ondemand homedir
  FZF_VERSION=0.29.0
  FZF_LINUX_AMD64_BIN="https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
  download_binary_for_ondemand ${FZF_LINUX_AMD64_BIN}

  # Download fd binary and put it in ondemand homedir
  FD_VERSION=v8.3.2
  FD_LINUX_BIN="https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  download_binary_for_ondemand ${FD_LINUX_BIN} 1

  # Download bat binary and put it in ondemand homedir
  BAT_VERSION=v0.20.0
  BAT_LINUX_BIN="https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  download_binary_for_ondemand ${BAT_LINUX_BIN} 1
}

git submodule update --init --recursive --remote
install_deps
symlink_dotfiles ~  # Symlink dotfiles to homedir
git config --global include.path ~/.delta.gitconfig  # git-delta config
fb_dev_setup

echo "Done setting up dotfiles!"
