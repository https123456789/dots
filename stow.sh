#!/usr/bin/env bash

pushd packages
stow -t $HOME/.config .config
stow -t $HOME home

mkdir -p $HOME/.config/nvim
stow -t $HOME/.config/nvim neovim
popd
