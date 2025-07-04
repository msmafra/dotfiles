#!/usr/bin/env bash
########################################################
#
# This is not ready. Just an idea to be worked on another time
# Work In Progress
#
#
#
########################################################
# $(sed -e '1q' "$GIT_DIR/description")
# css files that must be changed are from:
# # nwg-drawer, nwg-bar, waybar, swaync and wlogout
# hyprland.conf
# hyprlock.conf
# TODO/Ideas
## for the css ones, isolate the reset section (*{all:unset etc}) in one
## file and share it like the color palette files. So there will be only one
## file to change in that area
## line to search in the css file: only the first border-radius:
## line to search in the hyprland.conf file: rounding =
## line to search in the hyprlock.conf file: rounding = and # dots_text_format = 󰨓
## instead of getting the font-size from an argument of this script, get it from
## the .css file, to make the calculation automatic

set_rouding() {
    local -i round_v
    local css_line
    local hypr_line

    css_line="border-radius: rem"
    hypr_line="rounding = "

    case "${round_v}" in

    0)
        # this will replace
        sed -E '0,/border-radius: ([0-9]{0,})(\.{0,})([0-9]{0,})rem/s//border-radius: 44rem/' ~/.config/hypr/waybar/sharp.css
        sed -E '0,/rounding = ([0-9]{1,})/s//rounding = 4/' test
        ;;
    [0-9]{1,}) ;;
    esac

}

calc_rounding() {
    local -i new_round
    local -i font_size
    local rem_rounding

    rem_rounding="$(printf "%s %s" "${new_round:-4}" "${font_size:-16}" | awk '{printf "%.2f", $1/$2}')"

    printf "rouding = %s and border-radius: %srem\n" "${1}" "${rem_rounding}"
}
calc_rounding "${@}"
