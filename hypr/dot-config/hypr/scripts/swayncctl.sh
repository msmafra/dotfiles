#!/usr/bin/env bash
# This is for restart swaync, usually, for testing new settings and/or if there are @import in the style file
# both the config (jsonc) and the style (css) file must have the same name for simplicity.
# Is worth to open on a secondary terminal window, if not using the directly method, with
# journalctl --follow --output=short-iso $(command -v swaync) for monitoring in case of mistakes in the config
swaync_reload() {
    local primary_path
    local config_name
    local method
    local SCRIPT_NAME
    # local SCRIPT_FOLDER
    SCRIPT_NAME="$(basename "${0}")"
    # SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    primary_path="${HOME}/.config/hypr/swaync"
    method="${1}"
    config_name="${2}"

    case "${method}" in
    uwsm)
        # solves problem of not able to use bightness control
        printf "%s\n" "Killing swaync"
        killall swaync
        printf "Starting swaync with the theme %s via %s as background graphical\n" "${config_name}" "${method}"
        uwsm app -s b -t service -- swaync --config "${primary_path}/${config_name:-config}.json" --style "${primary_path}/${config_name:-style}.css"
        ;;
    hyprland)
        # solves problem of not able to use bightness control
        printf "%s\n" "Killing swaync"
        killall swaync
        printf "Starting swaync with the theme %s via %s as background graphical\n" "${config_name}" "${method}"
        hyprctl dispatch -- exec swaync --config "${primary_path}/${config_name:-config}.json" --style "${primary_path}/${config_name:-style}.css"
        ;;
    directly)
        printf "%s\n" "Killing swaync"
        killall swaync
        printf "%s\n" "Starting swaync %s so can be monitored (no debug paramenters used) if any warnings or errors occur." "${method}"
        swaync --config "${primary_path}/${config_name:-config}.json" --style "${primary_path}/${config_name:-style}.css" &
        disown
        ;;
    reload)
        # To reload the configuration without restarting
        printf "%s\n" "Reloading swaync"
        swaync-client --reload-config
        ;;
    hide)
        # You can toggle the visibility of the bars with:
        printf "%s\n" "Toggling swaync's visibility"
        swaync-client --toggle-panel --subscribe-waybar --count
        ;;
    *)
        printf "Usage: %s <method> <config_name>\n" "${SCRIPT_NAME}"
        printf "%s\n%s\n" "<method>: uwsm, hyprland, directly, reload and hide" "<config_name>: empty or name without extension (will be used for both jsonc and css)"
        printf "Not passing a configuration name for %s, will make it fallback to the defaults: config.json and style.css" "${SCRIPT_NAME}"
        ;;
    esac
}

swaync_reload "${@}"
