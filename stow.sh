#!/usr/bin/env bash

pushd packages
stow -t $HOME/.config .config -vv
stow -t $HOME home -vv
popd
