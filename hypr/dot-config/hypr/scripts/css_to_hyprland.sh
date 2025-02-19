#!/usr/bin/env bash
# To convert my pelette.css file to a hyprland compatible paletee.conf file
# CSS file is just the colors in the format @define-color <name> <rgb color>;
#
gen_hypr_palette() {
    local HYPR_PATH
    local CONF_FILE

    HYPR_PATH="$HOME/.config/hypr"
    CONF_FILE="palette.conf"

    awk 'BEGIN{FS=OFS=" "}{print "$"$2,"= "$3,$4,$5}' "${HYPR_PATH}/waybar/palette.css" | sed 's/;//' | tee "${HYPR_PATH}/conf/${CONF_FILE}"

}
gen_hypr_palette
