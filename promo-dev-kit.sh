# !/bin/bash

# request admin permissions
echo "This script requires admin privileges. Trying to gain root permissions..."
# set admin credentials temporary
sudo echo

is_kit_installed() {
    if command -v $1 >/dev/null 2>&1; then
        return 0  # true
    else
        return 1  # false
    fi
}


# install: brew
if ! is_kit_installed "brew" ; then
    echo "========== Installing Brew 🛠️ =========="
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "========== Successfully Installed Brew 🛠️ =========="
fi

# install: git
if ! is_kit_installed "git" ; then
    echo "========== Installing Git 🪄 =========="
    brew install git
    echo "========== Successfully Installed Git 🪄 =========="
fi

# install: golang
if ! is_kit_installed "go" ; then
    echo "========== Installing Go 1.22 🔗 =========="
    brew install go@1.20

    # set GOPRIVATE
    go env -w GOPRIVATE=github.com/tokopedia

    # set GOARCH
    go env -w GOARCH=amd64

    echo "========== Successfully Installed Go.1.20 🔗 =========="
fi

# install: make
if ! is_kit_installed "make" ; then
    echo "========== Installing Make 🔌 =========="
    brew install make
    echo "========== Successfully Installed Make 🔌 =========="
fi

# install: gcloud
if ! is_kit_installed "gcloud" ; then
    echo "========== Installing Gcloud 🚀 =========="
    curl https://sdk.cloud.google.com | bash
    exec -l $SHELL
    echo "========== Successfully Installed Gcloud 🚀 =========="
fi

# install: protoc
if ! is_kit_installed "protoc" ; then
    echo "========== Installing Protoc 🍭 =========="

    # install protoc
    PROTOC_ZIP=protoc-3.5.1-osx-x86_64.zip
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.5.1/$PROTOC_ZIP
    sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
    sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
    rm -f $PROTOC_ZIP
    sudo chmod +x /usr/local/bin/protoc

    # install protoc-gen-go
    go install github.com/golang/protobuf/protoc-gen-go@v1.0.0
    
    # fixing issue protobuf timestamp
    INCLUDE_FOLDER_PATH="/usr/local/include"
    if [ ! -d "$INCLUDE_FOLDER_PATH" ]; then
        echo "$INCLUDE_FOLDER_PATH is not exist"
        exit 1
    fi
    folder_owner=$(ls -ld $INCLUDE_FOLDER_PATH | awk '{print $3}')
    sudo chown -R $USER $INCLUDE_FOLDER_PATH

    echo "========== Successfully Installed Protoc 🍭 =========="
fi

# install: nsq
if ! is_kit_installed "nsqd" ; then
    echo "========== Installing NSQ 📨 =========="
    brew install nsq
    echo "========== Successfully Installed NSQ 📨 =========="
fi

# install: redis
if ! is_kit_installed "redis-server" ; then
    echo "========== Installing Redis 📦 =========="
    brew install redis
    brew services start redis
    echo "========== Successfully Installed Redis 📦 =========="
fi

# install: mockgen
if ! is_kit_installed "mockgen" ; then
    echo "========== Installing Mockgen 🎭 =========="
    go install github.com/golang/mock/mockgen@v1.6.0
    echo "========== Successfully Installed Mockgen 🎭 =========="
fi

# zsh: fixing config and re-compile 
if is_kit_installed "zsh" ; then
    echo "========== Adding export binary to Zsh 🎀 =========="

    ZSHRC_PATH="$HOME/.zshrc"

    # Check if the .zshrc file exists
    if [ ! -f "$ZSHRC_PATH" ]; then
        echo "Error: .zshrc file not found at $ZSHRC_PATH"
        exit 1
    fi

    # export homebrew
    if ! grep -q 'PATH=/opt/homebrew/bin:$PATH' $ZSHRC_PATH; then
        echo 'export PATH=/opt/homebrew/bin:$PATH' >> $ZSHRC_PATH
    fi

    # export go_path
    if ! grep -q 'GOPATH=$HOME/go' $ZSHRC_PATH; then
        echo 'export GOPATH=$HOME/go' >> $ZSHRC_PATH
    fi

    # add go_path in path
    if ! grep -q 'PATH=$PATH:$GOPATH/bin' $ZSHRC_PATH; then
        echo 'export PATH=$PATH:$GOPATH/bin' >> $ZSHRC_PATH
    fi

    zsh -c "source $ZSHRC_PATH"
    echo "========== Successfully Added export binary to Zsh 🎀 =========="
fi

# install: vscode
 if [ ! -d "/Applications/Visual Studio Code.app" ] && [ ! -d "$HOME/Applications/Visual Studio Code.app" ]; then
    echo "========== Installing Visual Studio Code 💻 =========="
    brew install --cask visual-studio-code
    echo "========== Successfully Installed Visual Studio Code 💻 =========="
fi

# install: postman
if [ ! -d "/Applications/Postman.app" ] && [ ! -d "$HOME/Applications/Postman.app" ]; then
    echo "========== Installing Visual Studio Code ☎️ =========="
    brew install --cask postman
    echo "========== Successfully Installed Visual Studio Code ☎️ =========="
fi

# install: dbeaver
if [ ! -d "/Applications/DBeaver.app" ] && [ ! -d "$HOME/Applications/DBeaver.app" ]; then
    echo "========== Installing DBeaver 💾 =========="
    brew install --cask dbeaver-community
    echo "========== Successfully Installed DBeaver 💾 =========="
fi

echo "========== Happy Dev 😁 =========="