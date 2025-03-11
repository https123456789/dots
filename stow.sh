#!/usr/bin/env bash

pushd packages
stow -t $HOME/.config .config
stow -t $HOME home
popd
