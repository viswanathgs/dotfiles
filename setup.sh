#!/usr/bin/env zsh

# Requirements: iterm2 and zsh, homebrew, python-pip
# Set zsh as default: chsh -s /bin/zsh

# Update submodules
git submodule update --init --recursive --remote

# Dependencies
pip install --upgrade ufmt black pre-commit tabcompletion cpplint ptpython pdbpp || true

function brewIn() {
  if brew ls --versions "$1"; then
    brew upgrade "$1"
  else
    brew install "$1"
  fi
}

MAC_DEPS=(
  clang-format
  hub
  fzf  # https://github.com/junegunn/fzf
  fd  # find++ - fzf uses underneath
  ripgrep  # grep++ - fzf uses underneath
  bat  # cat++ - fzf uses underneath for previews if installed
  tree  # for fzf previews of dir trees
  git-delta  # improved diff viz - https://github.com/dandavison/delta
  reattach-to-user-namespace  # tmux access to clipboard: https://blog.carbonfive.com/copying-and-pasting-with-tmux-2-4
  wget
)

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

# List of files to symlink to homedir
dotfiles=()
for f in $(ls -a | grep '^\.'); do
  if ! [[ ($f == .)  || ($f == ..) || ($f =~ "^\.git.*") || ($f =~ "\.sw.*") ]]; then
    dotfiles+=($f)
  fi
done

# Actually symlink to homedir
for f in "${dotfiles[@]}"; do
  echo "Symlink: ~/$f -> $(pwd)/$f"
  ln -sF $(pwd)/$f ~/
done

# Add gitconfig for git-delta to global gitconfig
git config --global include.path ~/.delta.gitconfig

# FB dev
# Also symlink to ~/.ondemand/homedir for ondemand dot-file sync
ONDEMAND_HOMEDIR=~/.ondemand/homedir
echo "Symlinking dotfiles to ${ONDEMAND_HOMEDIR}/"
mkdir -p ${ONDEMAND_HOMEDIR}
for f in ${dotfiles[@]}; do
  ln -sF $(pwd)/$f ${ONDEMAND_HOMEDIR}/
done

# Download fzf binary and put it in ondemand homedir
echo "Downloading fzf binary to ${ONDEMAND_HOMEDIR}/bin/"
mkdir -p ${ONDEMAND_HOMEDIR}/bin
FZF_LINUX_AMD64_BIN="https://github.com/junegunn/fzf/releases/download/0.28.0/fzf-0.28.0-linux_amd64.tar.gz"
wget -qO- ${FZF_LINUX_AMD64_BIN} | tar xz - -C ${ONDEMAND_HOMEDIR}/bin/

# Download fd binary and put it in ondemand homedir
echo "Downloading fd binary to ${ONDEMAND_HOMEDIR}/bin/"
mkdir -p ${ONDEMAND_HOMEDIR}/bin
FD_LINUX_BIN="https://github.com/sharkdp/fd/releases/download/v8.3.0/fd-v8.3.0-x86_64-unknown-linux-gnu.tar.gz"
wget -qO- ${FD_LINUX_BIN} | tar xz - -C ${ONDEMAND_HOMEDIR}/bin/
cp ${ONDEMAND_HOMEDIR}/bin/fd-*/fd ${ONDEMAND_HOMEDIR}/bin/

echo "Done setting up dotfiles!"
