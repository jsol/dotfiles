#!/bin/bash

req=(npm jq git fd rg bash-language-server harper-ls typos-lsp vscode-json-language-server go kitty)

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

mkdir -p "$DEST/nvim"
ln -sf "$ROOT/nvim/init.lua" "$DEST/nvim/"

mkdir -p "$DEST/tmux"
ln -sf "$ROOT/tmux/tmux.conf" "$DEST/tmux/"

mkdir -p "$DEST/kitty"
ln -sf "$ROOT/kitty/kitty.conf" "$DEST/kitty/"
ln -sf "$ROOT/kitty/tokyonight.conf" "$DEST/kitty/"
