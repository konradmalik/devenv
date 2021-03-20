#!/bin/sh
set -e

# install prerequisites
eval $APT_INSTALL software-properties-common make curl gpg-agent git
# add neovim repo and install prereqs
add-apt-repository ppa:neovim-ppa/unstable
eval $APT_INSTALL neovim
# add and install nodejs (nodejs contains npm package here)
curl -sL https://deb.nodesource.com/setup_$node_version.x | bash -
eval $APT_INSTALL nodejs 

# install language servers
# python
eval $APT_INSTALL python3 python3-pip python-is-python3
npm install -g pyright tree-sitter-cli --unsafe-perm=true
eval $PIP_INSTALL virtualenv
# go
eval $APT_INSTALL golang
su - dev -c "go get golang.org/dl/go$go_version"
su - dev -c "$GOPATH/bin/go$go_version download"
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=stable
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o /usr/local/bin/rust-analyzer
chmod +x /usr/local/bin/rust-analyzer

# cleanup
rm -rf /var/lib/apt/lists/* \
/etc/apt/sources.list.d/cuda.list \
/etc/apt/sources.list.d/nvidia-ml.list 

#RUN nvim --headless +PackerInstall +q
