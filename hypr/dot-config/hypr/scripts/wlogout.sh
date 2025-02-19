#!/usr/bin/env bash

wayland_logout() {
    local config
    local CSS
    local LAYOUT
    local -a PROTOCOL

    config="$HOME/.config/hypr/wlogout/"
    CSS="${config}/sharp.css"
    LAYOUT="${config}/layout"
    PROTOCOL=(
        "layer-shell"
        "xdg"
    )

    wlogout -p "${PROTOCOL[0]}" -s -C "${CSS}" -l "${LAYOUT}" -c 20 -r 20

}
wayland_logout