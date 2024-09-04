#!/usr/bin/env bash

pushd packages
stow -t $HOME/.config .config -vv
stow -t $HOME home -vv
stow -t $HOME/.config/nvim neovim -vv
popd
