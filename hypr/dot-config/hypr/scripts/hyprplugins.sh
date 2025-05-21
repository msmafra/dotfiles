#!/usr/bin/env bash
# Script to toggle hyprbars mainly for using with Waybar
# Will toggle hyprbars and provide status and tooltip text to be used in Waybar
# Is not a smooth transition since hyprclt will unload and reload instead of hide and show the bar
# Information from Waybar Wiki
# # # When return-type is set to json, Waybar expects the exec-script to output its data in JSON format.
# # # This should look like this: {"text": "$text", "alt": "$alt", "tooltip": "$tooltip", "class": "$class", "percentage": $percentage }.
# # # This means the output should also be on a single line. This can be achieved by piping the output of your script
# # # through jq --unbuffered --compact-output. The class parameter also accepts an array of strings.
toggle_bars() {
    local COMMAND
    local RUNNING
    local STATUS
    local STATUS
    local PLUGINS_PATH
    local -A PLUGINS

    if [[ "${#*}" -lt 2 ]]; then
        echo "two parameters are needed"

    fi

    COMMAND="${1}"
    PLUGIN="${2}"
    PLUGINS_PATH="/usr/lib64/hyprland"
    RUNNING="$(hyprctl -j plugin list | jq --raw-output ".[] | select(.name | contains(\""${PLUGIN}\"")) | .name")"
    PLUGINS=(
        ["bars"]="libhyprbars.so"
        ["borders"]="libborders-plus-plus.so"
    )

    if [[ ${RUNNING} =~ "${PLUGINS[${PLUGIN}]}" ]]; then
        ICON=""
        STATUS="Enabled"
        MESSAGE="${PLUGIN} enabled ${ICON}"
    else
        ICON=""
        STATUS="Disabled"
        MESSAGE="${PLUGIN} disabled ${ICON}"
    fi

    if [[ "${COMMAND}" = "toggle" ]]; then
        case "${STATUS}" in
        "Enabled")
            hyprctl plugin unload "${PLUGINS_PATH}/${PLUGINS[${PLUGIN}]}" 1>&2 >/dev/null
            ;;
        "Disabled")
            hyprctl plugin load "${PLUGINS_PATH}/${PLUGINS[${PLUGIN}]}" 1>&2 >/dev/null
            ;;
        esac
    fi
    printf "{\"text\": \"%s\", \"alt\": \"%s\", \"tooltip\": \"%s\", \"class\": \"%s\" }" "${MESSAGE}" "${STATUS}" "${MESSAGE}" "${STATUS}" | jq --unbuffered --compact-output

}
# toggle_bars "${@}"
