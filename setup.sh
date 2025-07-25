#!/bin/bash

req=(npm jq git fd rg bash-language-server harper-ls typos-lsp vscode-json-language-server go kitty nvim tmux)

for cmd in ${req[@]}; do
  if ! command -v "$cmd"; then
    echo "!! Missing dependency $cmd"
  fi
done

if ! [ -d ~/.tmux ]; then
  echo "!! Install tmux package manager"
fi

ROOT=`git rev-parse --show-toplevel`
DEST=~/.config

mkdir -p "$DEST/nvim/lua"
ln -sf "$ROOT/nvim/init.lua" "$DEST/nvim/"
for s in "$ROOT"/nvim/lua/*.lua; do
  ln -sf "$s" "$DEST/nvim/lua/"
done

ln -sf "$ROOT/nvim/init.lua" "$DEST/nvim/"

mkdir -p "$DEST/tmux"
ln -sf "$ROOT/tmux/tmux.conf" "$DEST/tmux/"

mkdir -p "$DEST/nix"
ln -sf "$ROOT/nix/nix.conf" "$DEST/nix/"

# Setting up the tmux plugin manager and downloading the plugins
if ! [ -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
fi

mkdir -p "$DEST/kitty"
ln -sf "$ROOT/kitty/kitty.conf" "$DEST/kitty/"
ln -sf "$ROOT/kitty/tokyonight.conf" "$DEST/kitty/"
