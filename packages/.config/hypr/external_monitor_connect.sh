#!/bin/bash


handle() {
    if [[ $1 == *"monitoradded"* ]]; then
        hyprctl dispatch moveworkspacetomonitor "1 1"
        hyprctl dispatch moveworkspacetomonitor "2 1"
        hyprctl dispatch moveworkspacetomonitor "3 1"
        hyprctl dispatch moveworkspacetomonitor "4 1"
        hyprctl dispatch moveworkspacetomonitor "5 1"
        hyprctl dispatch moveworkspacetomonitor "6 1"
        hyprctl dispatch moveworkspacetomonitor "7 1"
        hyprctl dispatch moveworkspacetomonitor "8 1"
        hyprctl dispatch moveworkspacetomonitor "9 1"

        # Waybar will get a bit messed up so we can reload it
        kill -SIGUSR2 $(pidof waybar)
    fi
}

socat - "UNIX-CONNECT:/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | \
    while read -r line; do handle "$line"; done
