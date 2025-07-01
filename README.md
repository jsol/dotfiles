# dotfiles

## Dependencies (Debian / Ubuntu)
````
### nvim
sudo apt install clangd fd-find
ln -s $(which fdfind) ~/.local/bin/fd

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
npm i -g bash-language-server
npm i -g vscode-langservers-extracted

cargo install harper-ls --locked
wget https://github.com/tekumara/typos-lsp/releases/download/v0.1.29/typos-lsp-v0.1.29-x86_64-unknown-linux-gnu.tar.gz && tar -xzvf typos-lsp-* -C ~/.local/bin

Meson lsp:
https://github.com/JCWasmx86/mesonlsp/releases/tag/v4.3.7

Marksman LSP
wget https://github.com/artempyanykh/marksman/releases/download/2024-11-20/marksman-linux-arm64 && chmod a+x marksman-linux-arm64 && mv marksman-linux-arm64 ~/.local/bin

### Fonts
Font Awesome for icons
JetBrains Mono for ligature aware mono font (either through nerd fonts or https://www.jetbrains.com/lp/mono/)

### tmux
Plugin manager should be installed by the setup script.
````

## Install dependencies into nix profile instead
nix profile install \
    nixpkgs#bash-language-server \
    nixpkgs#fd \
    nixpkgs#go \
    nixpkgs#gopls \
    nixpkgs#harper \
    nixpkgs#marksman \
    nixpkgs#meson \
    nixpkgs#mesonlsp \
    nixpkgs#neovim \
    nixpkgs#nix \
    nixpkgs#ripgrep \
    nixpkgs#typos \
    nixpkgs#vscode-langservers-extracted

The upside of nix is updating is easier with nix profile update --all

## Install
Just run the setup.sh script. It will symlink the config and check that the dependencies are installed.

Start nvim to install its plugins.
Start tmux and press "ctrl-b I" to setup the plugins
