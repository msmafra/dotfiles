#!/usr/bin/env bash
# IDEAS
# use hud combining with a keybind to show what is opened inside that workspace
# something like
# nwg-hud -t 3000 -m "$(hyprctl -j clients | jq -r '.[] | select(.workspace.id == 2) | .class,.title, "\n"')"
# nwg-hud -t 3000 -m "$(hyprctl -j clients | jq -r '.[] | select(.workspace.id == 2) | .workspace.id, .class')"
#
# workspace>>1
# workspacev2>>1,1
# closelayer>>nwg-hud
# openlayer>>nwg-hud
# closelayer>>nwg-hud
# activewindow>>kitty,/home/coop/.config/h ~
# activewindowv2>>556769e99310
# createworkspace>>special:nebula
# createworkspacev2>>-98,special:nebula
# activewindow>>,
# activewindowv2>>
# activespecial>>special:nebula,HDMI-A-1
# activespecial>>,HDMI-A-1
# activewindow>>kitty,/home/coop/.config/h ~
# activewindowv2>>556769e99310
# destroyworkspace>>special:nebula
# destroyworkspacev2>>-98,special:nebula
#
# submap>>Resize mode
# submap>>

function showing_hud

    set workspace_types "workspace>>*" "activespecial>>*"
    set submap "submap>>"
    set floating_state "changefloatingmode>>"
    set TIMEOUT 1000

    switch "$argv"
        case "workspace*"
            nwg-hud -t "$TIMEOUT" -m "  Workspace {$1//[^[:digit:]]/}"
        case "activespecial*"
            set workspace_name "$(printf "%s" "$argv" | xargs -0 | grep -Po "(?<=:)(.*?)(?=,)")"
            nwg-hud -t "$TIMEOUT" -m "  Workspace {$workspace_name}"
        case "$submap"
            nwg-hud -t 1000 -m "󰙖  Submap: {$1:8}" -va bottom
        case "*"
            printf "%s\n" "Nothing to do."
    end

    # if [[ ${1:0:11} == "${workspace_types[0]}" ]]; then

    # 	nwg-hud -t "${TIMEOUT}" -m "  Workspace ${1//[^[:digit:]]/}"

    # elif [[ ${1:0:15} == "${workspace_types[1]}" ]]; then

    # 	workspace_name="$(printf "%s" "${1}" | xargs -0 | grep -Po "(?<=:)(.*?)(?=,)")"
    # 	nwg-hud -t "${TIMEOUT}" -m "  Workspace ${workspace_name}"

    # elif [[ "${1}" =~ ${submap} ]]; then

    # 	nwg-hud -t 1000 -m "󰙖  Submap: ${1:8}" -va bottom

    # else

    # 	printf "%s\n" "Nothing to do."

    # fi

end

function main

    set HYPRLAND_PATH
    set LOCKFD
    set SCRIPT_NAME
    set SCRIPT_FOLDER
    set LOCKFILE
    set LOCKFILE
    set LOCKFD
    set TIMEOUT

    set HYPRLAND_PATH "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE"
    set SCRIPT_NAME "$(basename "$0")"
    set SCRIPT_FOLDER "$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
    set LOCKFILE "$HYPRLAND_PATH/$(basename "$0").lock"
    set LOCKFD 99
    set TIMEOUT 1000


    # Monitor Hyprland's Socket 2
    while read -l line
        showing_hud "$line"
    end | socat -U - "UNIX-CONNECT:$HYPRLAND_PATH/.socket2.sock"
end

main
