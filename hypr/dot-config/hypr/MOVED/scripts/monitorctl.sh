#!/usr/bin/env bash
#
#
monitorsctl() {

    if [[ "${XDG_CURRENT_DESKTOP}" == "niri" ]]; then
        niri msg action power-off-monitors
    else
        hyprctl dispatch dpms toggle
    fi

}
monitorsctl
