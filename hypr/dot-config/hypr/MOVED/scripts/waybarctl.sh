#!/usr/bin/env bash
# This is for restart waybar, usually, for testing new settings and/or if there are @import in the style file
# both the config (jsonc) and the style (css) file must have the same name for simplicity.
# Is worth to open on a secondary terminal window, if not using the directly method, with
# journalctl --follow --output=short-iso $(command -v waybar) for monitoring in case of mistakes in the config
waybar_reload() {
    local primary_path
    local config_name
    local method
    local SCRIPT_NAME
    # local SCRIPT_FOLDER
    SCRIPT_NAME="$(basename "${0}")"
    # SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    primary_path="${HOME}/.config/hypr/waybar"
    method="${1}"
    config_name="${2}"

    case "${method}" in
    uwsm)
        # solves problem of not able to use bightness control
        printf "%s\n" "Killing waybar"
        killall waybar
        printf "Starting waybar with the theme %s via %s as background graphical\n" "${config_name}" "${method}"
        uwsm app -s b -t service -- waybar --bar "${config_name}bar" --config "${primary_path}/${config_name:-config}.jsonc" --style "${primary_path}/${config_name:-style}.css"
        ;;
    hyprland)
        # solves problem of not able to use bightness control
        printf "%s\n" "Killing waybar"
        killall waybar
        printf "Starting waybar with the theme %s via %s as background graphical\n" "${config_name}" "${method}"
        hyprctl dispatch -- exec waybar --bar "${config_name}bar" --config "${primary_path}/${config_name:-config}.jsonc" --style "${primary_path}/${config_name:-style}.css"
        ;;
    directly)
        printf "%s\n" "Killing waybar"
        killall waybar
        printf "%s\n" "Starting waybar %s so can be monitored (no debug paramenters used) if any warnings or errors occur." "${method}"
        waybar --bar "${config_name}bar" --config "${primary_path}/${config_name:-config}.jsonc" --style "${primary_path}/${config_name:-style}.css" &
        disown
        ;;
    reload)
        # To reload the configuration without restarting
        printf "%s\n" "Reloading waybar"
        killall -SIGUSR2 waybar
        ;;
    hide)
        # You can toggle the visibility of the bars with:
        printf "%s\n" "Toggling waybar's visibility"
        killall -SIGUSR1 waybar
        ;;
    *)
        printf "Usage: %s <method> <config_name>\n" "${SCRIPT_NAME}"
        printf "%s\n%s\n" "<method>: hyprland, directly, reload, hide" "<config_name>: empty or name without extension (will be used for both jsonc and css)"
        printf "Not passing a configuration name for %s, will make it fallback to the defaults: config.jsonc and style.css" "${SCRIPT_NAME}"
        ;;
    esac
}

waybar_toggle() {
    # gets the highest value from the reserved area in which waybar is shown. Format is [ 0, 0, 30, 0]
    # this will return 0 if waybar is hidden or and integer for the height of waybar
    local -i reserved_status
    local workspace_name

    reserved_status="$(hyprctl monitors -j | jq -r '[ .[] | .reserved | max] | max')"
    workspace_name="Game"

    if test "$(hyprctl activeworkspace -j | jq -r '.name')" = "Gaming"; then
        echo teste
    fi

    if [[ "${reserved_status}" -eq 0 ]]; then
        printf "waybar is hidden (height %s). Reloading to be shown again\n" "${reserved_status}"
        killall -SIGUSR2 waybar

    fi
}

waybar_reload "${@}"
