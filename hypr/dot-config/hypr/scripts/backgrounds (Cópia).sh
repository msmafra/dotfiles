#!/usr/bin/env bash

# based on https://johnnymatthews.dev/blog/2021-05-14-random-wallpaper-script/
# randomizes background images for hyprlock and hyprpaper. for hyprlock it applies effects

random_hyprlock() {

    local WALLPAPER_DIR
    local RANDOM_PICTURE_PATH
    local TMP_FILE
    local HYPRLOCK_BG
    local HYPR_DIR
    local -i FREQ

    WALLPAPER_DIR="${HOME}/Imagens/Wallpapers"
    RANDOM_PICK="$(find "${WALLPAPER_DIR}" | shuf -n 1)"
    HYPRLAND_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE"

    waypaper --backend hyprpaper --restore --random --fill fill --folder "${WALLPAPER_DIR}"

    RANDOM_PICTURE_PATH="$(waypaper --list | grep -v "We got: en" | jq -r '.[] .wallpaper')"
    RANDOM_PICTURE="$(basename "${RANDOM_PICTURE_PATH}")"
    TMP_DIR="/tmp"
    HYPR_DIR="$HOME/.config/hypr"
    HYPRLOCK_BG="${HYPR_DIR}/hyprlock-background"
    MONITORS_QTY="$(hyprctl -j monitors | jq -r '.[] .id' | wc -l)"
    FREQ=60

    cp --verbose --force "${RANDOM_PICTURE_PATH}" "${TMP_DIR}/background.jpg"
    cp --verbose --force "${RANDOM_PICTURE_PATH}" "${HYPRLAND_PATH}/background.jpg"

    # for reference, won't be used by waypaper with sww, but was used by my configuration fo hyprpaper
    ln --force --symbolic --verbose "${RANDOM_PICTURE_PATH}" "$HYPR_DIR/wallpaper.jpg"

    if [[ -L "${HYPRLOCK_BG}" ]]; then
        rm --verbose "${HYPRLOCK_BG}"
    fi

    #magick "${RANDOM_PICTURE_PATH}" -blur 0x4 $TMP_FILE && feh $HYPRLOCK_BG
    #magick "${TMP_FILE}" -fill black -colorize 40% -virtual-pixel edge -channel R -fx p[-5,-12] -channel B -fx p[12,5] "${HYPRLOCK_BG}"
    magick "${TMP_DIR}/background.jpg" -virtual-pixel edge -channel R -fx p[-10,-24] -channel B -fx p[24,10] -blur 0x18 "${HYPRLOCK_BG}"

    unset WALLPAPER_DIR RANDOM_PICK RANDOM_PICTURE_PATH TMP_FILE HYPRLOCK_BG

}
random_hyprlock
