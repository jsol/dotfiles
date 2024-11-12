# dotfiles

## Dependencies (Debian / Ubuntu)
````
# nvim
sudo apt install clangd fd-find
ln -s $(which fdfind) ~/.local/bin/fd

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
npm i -g bash-language-server
npm i -g vscode-langservers-extracted

cargo install harper-ls --locked
wget https://github.com/tekumara/typos-lsp/releases/download/v0.1.29/typos-lsp-v0.1.29-x86_64-unknown-linux-gnu.tar.gz && tar -xzvf typos-lsp-* -C ~/.local/bin


# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
````

## Install
Just run the install.sh script. It will symlink the config and check that the dependencies are installed.
