#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive

UPGRADE_PACKAGES=${1:-none}

if [ "${UPGRADE_PACKAGES}" != "none" ]; then
  echo "==> Updating and upgrading packages ..."

  # Add third party repositories
  sudo apt-get update
  sudo apt-get upgrade -y
fi

sudo apt-get install -qq \
  apache2-utils \
  apt-transport-https \
  build-essential \
  bzr \
  ca-certificates \
  clang \
  cmake \
  curl \
  direnv \
  dnsutils \
  docker.io \
  fakeroot-ng \
  gdb \
  git \
  git-crypt \
  gnupg \
  gnupg2 \
  htop \
  hugo \
  ipcalc \
  jq \
  less \
  libclang-dev \
  liblzma-dev \
  libpq-dev \
  libprotoc-dev \
  libsqlite3-dev \
  libssl-dev \
  libvirt-clients \
  libvirt-daemon-system \
  lldb \
  locales \
  man \
  mosh \
  mtr-tiny \
  musl-tools \
  ncdu \
  netcat-openbsd \
  openssh-server \
  pkg-config \
  protobuf-compiler \
  pwgen \
  python \
  python3 \
  python3-flake8 \
  python3-pip \
  python3-setuptools \
  python3-venv \
  python3-wheel \
  qemu-kvm \
  qrencode \
  quilt \
  ripgrep \
  shellcheck \
  silversearcher-ag \
  socat \
  software-properties-common \
  sqlite3 \
  stow \
  sudo \
  tig \
  tmate \
  tmux \
  tree \
  unzip \
  wget \
  zgen \
  zip \
  zlib1g-dev \
  vim-gtk3 \
  zsh \
  --no-install-recommends \

sudo rm -rf /var/lib/apt/lists/*

# install Go
if ! [ -x "$(command -v go)" ]; then
  echo " =>> Installing go"
  export GO_VERSION="1.14.2"
  wget "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
  sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
  rm -f "go${GO_VERSION}.linux-amd64.tar.gz"
  export PATH="/usr/local/go/bin:$PATH"
fi

# install 1password
#if ! [ -x "$(command -v op)" ]; then
#  export OP_VERSION="v0.5.6-003"
#  curl -sS -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/${OP_VERSION}/op_linux_amd64_${OP_VERSION}.zip
#  unzip 1password.zip op -d /usr/local/bin
#  rm -f 1password.zip
#fi

VIM_PLUG_FILE="${HOME}/.vim/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then
  echo " ==> Installing vim plugins"
  curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  mkdir -p "${HOME}/.vim/plugged"
  cd "${HOME}/.vim/plugged"
  git clone "https://github.com/AndrewRadev/splitjoin.vim"
  git clone "https://github.com/ConradIrwin/vim-bracketed-paste"
  git clone "https://github.com/Raimondi/delimitMate"
  git clone "https://github.com/SirVer/ultisnips"
  git clone "https://github.com/cespare/vim-toml"
  git clone "https://github.com/corylanou/vim-present"
  git clone "https://github.com/ekalinin/Dockerfile.vim"
  git clone "https://github.com/elzr/vim-json"
  git clone "https://github.com/fatih/vim-hclfmt"
  git clone "https://github.com/fatih/vim-nginx"
  git clone "https://github.com/fatih/vim-go"
  git clone "https://github.com/hashivim/vim-hashicorp-tools"
  git clone "https://github.com/junegunn/fzf.vim"
  git clone "https://github.com/mileszs/ack.vim"
  git clone "https://github.com/roxma/vim-tmux-clipboard"
  git clone "https://github.com/plasticboy/vim-markdown"
  git clone "https://github.com/scrooloose/nerdtree"
  git clone "https://github.com/t9md/vim-choosewin"
  git clone "https://github.com/tmux-plugins/vim-tmux"
  git clone "https://github.com/tmux-plugins/vim-tmux-focus-events"
  git clone "https://github.com/fatih/molokai"
  git clone "https://github.com/tpope/vim-commentary"
  git clone "https://github.com/tpope/vim-eunuch"
  git clone "https://github.com/tpope/vim-fugitive"
  git clone "https://github.com/tpope/vim-repeat"
  git clone "https://github.com/tpope/vim-scriptease"
  git clone "https://github.com/ervandew/supertab"
  cd ~
fi

if [ ! -d "$(go env GOPATH)" ]; then
  echo " ==> Installing Go tools"
  # vim-go tooling
  go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct
  go get -u -v github.com/mdempsky/gocode
  go get -u -v github.com/rogpeppe/godef
  go get -u -v github.com/zmb3/gogetdoc
  go get -u -v golang.org/x/tools/cmd/goimports
  go get -u -v golang.org/x/tools/cmd/gorename
  go get -u -v golang.org/x/tools/cmd/guru
  GO111MODULE=on go get -u -v golang.org/x/tools/cmd/gopls
  go get -u -v golang.org/x/lint/golint
  go get -u -v github.com/josharian/impl
  go get -u -v honnef.co/go/tools/cmd/keyify
  go get -u -v github.com/fatih/gomodifytags
  go get -u -v github.com/fatih/motion
  go get -u -v github.com/koron/iferr

  # generic
  go get -u -v github.com/aybabtme/humanlog/cmd/...
  go get -u -v github.com/fatih/hclfmt

  cp -r $(go env GOPATH)/bin/* /usr/local/bin/
fi

if [ ! -d "${HOME}/.zsh" ]; then
  echo " ==> Installing zsh plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/zsh-autosuggestions"
fi

if [ ! -d "${HOME}/.tmux/plugins" ]; then
  echo " ==> Installing tmux plugins"
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  git clone https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
  git clone https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
  git clone https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"
fi

echo "==> Setting shell to zsh..."
sudo chsh -s /usr/bin/zsh

echo "==> Creating dev directories"
mkdir -p ~/code



if ! [ -x "$(command -v nvm)" ]; then
 echo "===> Installing nvm"
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash
 nvm install v14.15.0
fi

if [ ! -d ~/code/dotfiles ]; then
  echo "==> Setting up dotfiles"
  # the reason we dont't copy the files individually is, to easily push changes
  # if needed
  cd "~/code"
  git clone --recursive https://github.com/pandocreek/dotfiles.git

  cd "~/code/dotfiles"
  git remote set-url origin git@github.com:pandocreek/dotfiles.git

  ln -sfn $(pwd)/vimrc "${HOME}/.vimrc"
  ln -sfn $(pwd)/zshrc "${HOME}/.zshrc"
  ln -sfn $(pwd)/tmuxconf "${HOME}/.tmux.conf"
  ln -sfn $(pwd)/gitconfig "${HOME}/.gitconfig"
fi

echo ""
echo "==> Done!"
