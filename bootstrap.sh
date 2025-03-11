#! /bin/bash

set -e

## Utilities ##

function stage_print() {
    gum style --foreground '#a6e3a1' --margin '0 0' --bold "$1"
}

function substage_print() {
    gum style --foreground '#94e2d5' --margin '0 2' --bold -- "-> $1"
}

## IronBar CSS ##

stage_print "Setting up IronBar CSS colors"
substage_print "Downloading Catppuccin CSS file"

LATEST_CATPPUCCIN_CSS_PATH=$(curl https://unpkg.com/@catppuccin/palette/css/catppuccin.css -s | \
    awk '{print $4}')
curl "https://unpkg.com/$LATEST_CATPPUCCIN_CSS_PATH" -s --output packages/.config/ironbar/catppuccin.css

substage_print "Patching Catppuccin CSS to GTK CSS"

# GTK uses `@define-color` rather than `--` for custom properties
sed -i -e 's/\s\s--/@define-color /gm' packages/.config/ironbar/catppuccin.css
sed -i -e 's/: / /gm' packages/.config/ironbar/catppuccin.css

# Only pick mocha (which is always the last section)
FIRST_CATPPUCCIN_MOCHA_CSS_LINE=$(cat packages/.config/ironbar/catppuccin.css | \
    grep -Hn ':root' | awk -F ':' '{print $2}' | tail -n 1)
sed -i "1,${FIRST_CATPPUCCIN_MOCHA_CSS_LINE}d" packages/.config/ironbar/catppuccin.css

# Extraneous `}`
sed -i -e '$d' packages/.config/ironbar/catppuccin.css

# GTK forbids comma-less rgb and hsl specifiers so we drop them
# Yes, it's ugly and there's probably a better way to do it but I'm lazy
sed -i -e 's/@define-color\s.*rgb.*;//gm' packages/.config/ironbar/catppuccin.css # RGB
sed -i -e 's/@define-color\s.*hsl.*;//gm' packages/.config/ironbar/catppuccin.css # HSL
sed -i -e '/^$/d' packages/.config/ironbar/catppuccin.css
sed -i -e 's/ctp-mocha/ctp/gm' packages/.config/ironbar/catppuccin.css

## SwayNC Catppuccin Theme ##

stage_print "Setting up SwayNC Catppuccin Theme"

substage_print "Generating CSS Files"

pushd packages/.config/swaync/swaync-catppuccin > /dev/null
npm ci --include=dev --silent
npm run build --silent

substage_print "Patching CSS to Use Fira Code"

pushd .. > /dev/null

cp swaync-catppuccin/dist/mocha.css style.css
sed -i -e 's/font-family: "Ubuntu Nerd Font";/font-family: "Fira Code Nerd Font";/g' style.css

popd > /dev/null
popd > /dev/null

stage_print "Done"
