#!/usr/bin/env bash

toggle_hyprbars() {

    local -i hide_y
    local -i cur_y
    local bar_status
    local config_dir
    local plugin_path

    hide_y=100 #120
    config_dir="${HOME}/.config/hypr/plugins.conf"
    plugin_path="/usr/lib64/hyprland/libhyprbars.so"
    # Shows the first line that must contain the plugin to be loaded
    #sed -e '1!d' ~/.config/hypr/plugins.conf
    # Shows the same line but filter by status "enabled"
    #sed -e '1!d' ~/.config/hypr/plugins.conf | grep -E "^plugin"
    # Shows the same line but filter by status "diabled"
    #sed -e '1!d' ~/.config/hypr/plugins.conf | grep -E "^#plugin"
    #sed -i 's|plugin = |#plugin = |g' ~/.config/hypr/plugins.conf

    while true; do

        sleep 1s
        cur_y=$(hyprctl -j cursorpos | jq '.y')
        bar_status=$(hyprctl plugins list | grep -E "Plugin hyprbars")

        if [[ "${cur_y}" -le "${hide_y}" ]]; then
            printf "%s\n" "Disabled"
            if [[ ! "${bar_status}" ]]; then
                hyprctl plugins load "${plugin_path}"
            fi
            printf "Less than or iquals %s\n" "${hide_y}"
        else
            printf "%s\n" "Enabled"
            hyprctl plugins unload "${plugin_path}"
            printf "Greater than %s\n" "${hide_y}"
        fi
    done
}
toggle_hyprbars
