#!/usr/bin/env bash

ghosttyimage() {

    local ghostty_exec
    local APPS
    APPS="$HOME/Applications"
    ghostty_exec="${APPS}/ghostty.AppImage"

    "${APPS}"/appimageupdatetool-x86_64.AppImage --self-update

    if "${APPS}"/appimageupdatetool-x86_64.AppImage --remove-old --overwrite "${ghostty_exec}"; then
        "${ghostty_exec}" --theme="Ayu Mirage" --gtk-titlebar=false --shell-integration-features=true --cursor-style="block" --background-opacity=1.0 --window-decoration=false &
    else
        echo "couldn't update"
    fi
}
ghosttyimage "${@}"
