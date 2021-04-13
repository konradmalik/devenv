#!/bin/sh
set -e

# install prerequisites
eval $APT_INSTALL software-properties-common make curl gpg-agent git
eval $APT_INSTALL -o Dpkg::Options::="--force-overwrite" bat ripgrep

# precreate dirs in home so they wont be root
su - dev -c "mkdir ~/.config"
su - dev -c "mkdir ~/.cache"
su - dev -c "mkdir ~/.local"
su - dev -c "mkdir ~/.cargo"

# add neovim repo and install prereqs
#add-apt-repository ppa:neovim-ppa/unstable
#eval $APT_INSTALL neovim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x ./nvim.appimage
./nvim.appimage --appimage-extract
# additional geek points
(cd ./squashfs-root/usr && tar c .) | (cd /usr && tar xf -)
rm -rf ./squashfs-root nvim.appimage

# install language servers
# efm - global for formatting only + prettier for json, yaml etc.
# add and install nodejs (nodejs contains npm package here)
curl -L https://github.com/mattn/efm-langserver/releases/download/v0.0.29/efm-langserver_v0.0.29_linux_amd64.tar.gz | tar xvfz - \
&& mv **/efm-langserver /usr/local/bin/efm-langserver && rm -rf efm-langserver*
curl -sL https://deb.nodesource.com/setup_$node_version.x | bash -
eval $APT_INSTALL nodejs
npm install -g prettier
# python
if [ -z "$enable_python" ]
then
    echo "\$enable_python is empty, not installing"
else
    echo "\$enable_python is set, installing"
	add-apt-repository ppa:deadsnakes/ppa
	eval $APT_INSTALL \
        python-is-python3 \
        python${python_version} \
        python${python_version}-dev \
        python3-distutils-extra
    curl -L -o ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py
    python${python_version} ~/get-pip.py
    rm -f ~/get-pip.py
    npm install -g pyright
    eval $PIP_INSTALL virtualenv
fi

# go
if [ -z "$enable_go" ]
then
    echo "\$enable_go is empty, not installing"
else
    echo "\$enable_go is set, installing"
    eval $APT_INSTALL golang
    su - dev -c "go get golang.org/dl/go$go_version"
    su - dev -c "$GOPATH/bin/go$go_version download"
    su - dev -c "go get golang.org/x/tools/cmd/goimports"
fi

# rust
if [ -z "$enable_rust" ]
then
    echo "\$enable_rust is empty, not installing"
else
    echo "\$enable_rust is set, installing"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=stable
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o /usr/local/bin/rust-analyzer
    chmod +x /usr/local/bin/rust-analyzer
fi

# tex
if [ -z "$enable_tex" ]
then
    echo "\$enable_tex is empty, not installing"
else
    echo "\$enable_tex is set, installing"
    PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')
    VERSION=$(curl -s "https://github.com/latex-lsp/texlab/releases/latest/download" 2>&1 | sed "s/^.*download\/\([^\"]*\).*/\1/")
    echo "Found texlab version: $VERSION"
    TEMP_FILE="$(mktemp)" \
    && TEMP_FOLDER="$(mktemp -d)" \
    && curl -o "$TEMP_FILE" -L "https://github.com/latex-lsp/texlab/releases/download/$VERSION/texlab-x86_64-$PLATFORM.tar.gz" \
    && tar xvzf "$TEMP_FILE" --directory="$TEMP_FOLDER/" \
    && mv "$TEMP_FOLDER/texlab" /usr/local/bin/ \
    && rm -rf "$TEMP_FILE" \
    && rm -rf "$TEMP_FOLDER"
    chmod +x /usr/local/bin/texlab
fi

# cleanup
rm -rf /var/lib/apt/lists/* \
/etc/apt/sources.list.d/cuda.list \
/etc/apt/sources.list.d/nvidia-ml.list 
