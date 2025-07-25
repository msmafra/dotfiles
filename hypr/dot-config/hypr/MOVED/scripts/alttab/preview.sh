#!/usr/bin/env bash
line="$1"

IFS=$'\t' read -r addr _ <<<"$line"
dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}

grim -t png -l 0 -w "$addr" ~/scripts/alttab/preview.png
chafa --animate false -s "$dim" "$XDG_CONFIG_HOME/scripts/alttab/preview.png"
