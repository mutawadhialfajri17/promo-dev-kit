# !/bin/bash

# request admin permissions
if [ "$EUID" -ne 0 ]; then
    echo "This script requires admin privileges. Trying to gain root permissions..."
    # Re-run the script with sudo
    sudo bash "$0" "$@"
    exit $?
fi

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
    echo "========== Install Brew is Complete 🛠️ =========="
fi

# install: git
if ! is_kit_installed "git" ; then
    echo "========== Installing Git 🪄 =========="
    brew install git
    echo "========== Install Git is Complete 🪄 =========="
fi

# install: golang
if ! is_kit_installed "go" ; then
    echo "========== Installing Go 1.22 🔗 =========="
    brew install go@1.22
    echo "========== Install Go 1.22 is Complete 🔗 =========="
fi

# install: make
if ! is_kit_installed "make" ; then
    echo "========== Installing Make 🔌 =========="
    brew install make
    echo "========== Install Make is Complete 🔌 =========="
fi

# install: gcloud
if ! is_kit_installed "gcloud" ; then
    echo "========== Installing Gcloud 🚀 =========="
    curl https://sdk.cloud.google.com | bash
    exec -l $SHELL
    echo "========== Install Gcloud is Complete 🚀 =========="
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
    user=$(whoami)
    include_folder_path="/usr/local/include"
    if [ ! -d "$include_folder_path" ]; then
        echo "$include_folder_path is not exist"
        exit 1
    fi
    folder_owner=$(ls -ld $include_folder_path | awk '{print $3}')
    sudo chown -R $user $include_folder_path

    echo "========== Install Protoc is Complete 🍭 =========="
fi

# install: nsq
if ! is_kit_installed "nsqd" ; then
    echo "========== Installing NSQ 📨 =========="
    brew install nsq
    echo "========== Install NSQ is Complete 📨 =========="
fi

# install: redis
if ! is_kit_installed "redis-server" ; then
    echo "========== Installing Redis 📦 =========="
    brew install redis
    brew services start redis
    echo "========== Install Redis is Complete 📦 =========="
fi

# zsh: fixing export and re-compile 
if is_kit_installed "zsh" ; then
    echo "========== Adding export binary to Zsh 🎀 =========="
    zshrc_path="~/.zshrc"

    # export homebrew
    if ! grep -q 'PATH=/opt/homebrew/bin:$PATH' ~/.zshrc; then
        echo 'export PATH=/opt/homebrew/bin:$PATH' >> ~/.zshrc
    fi

    # export go_path
    if ! grep -q 'GOPATH=$HOME/go' ~/.zshrc; then
        echo 'export GOPATH=$HOME/go' >> ~/.zshrc
    fi

    # add go_path in path
    if ! grep -q 'PATH=$PATH:$GOPATH/bin' ~/.zshrc; then
        echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
    fi

    # export others go lib binary
    if ! grep -q 'PATH=$PATH:/usr/local/go/bin' ~/.zshrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
    fi

    compile ~/.zshrc
    echo "========== Add export binary to Zsh is Complete 🎀 =========="
fi

echo "========== Happy Dev 😁 =========="