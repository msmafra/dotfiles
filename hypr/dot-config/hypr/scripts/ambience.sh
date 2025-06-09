#!/usr/bin/env bash
# inspired by https://johnnymatthews.dev/blog/2021-05-14-random-wallpaper-script/
# Randomizes wallpapers and generates an copy with effects for screen lockers.
# Background images hyprpaper or sww and apply a effects to its copy for use with hyprlock.
# maybe, if gnome-based system copy the user avatar /var/lib/AccountsService/icons/$USER and
# also apply the effects on it
main() {
    local GET_BACKEND
    local HYPRLAND_PATH
    local -a WP_BACKENDS
    local WALLPAPER_DIR
    local USE_BACKEND
    local TMP_DIR
    local HYPRLOCK_BG
    local HYPR_DIR

    HYPR_DIR="${HOME}/.config/hypr"
    HYPRLOCK_BG="${HYPR_DIR}/hyprlock-background"
    GET_BACKEND="${1}"
    GET_EFFECT="${2}"
    HYPRLAND_PATH="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}"
    WP_BACKENDS=( #hyprpaper as is the default must be the first in the array
        "hyprpaper"
        "swww-daemon"
        "swaybg"
    )
    WALLPAPER_DIR="${HOME}/Imagens/Wallpapers"
    TMP_DIR="/tmp"
    if [[ ! "${GET_BACKEND}" =~ ${WP_BACKENDS[*]} ]]; then
        USE_BACKEND="${WP_BACKENDS[0]}"
        printf "Backend not chosen or invalid (options: %s). Using default: %s\n" "${WP_BACKENDS[*]}" "${WP_BACKENDS[0]}"
    else
        USE_BACKEND="${GET_BACKEND}"
    fi

    args

    backend_check "${@}"
    image_generation "${@}"

    # set gtk flatpaks darkmode
    doas flatpak override --env=GTK_THEME=Adwaita-dark

    # compgen -v | grep -E "GET_BACKEND|HYPRLAND_PATH|WP_BACKENDS|WALLPAPER_DIR|USE_BACKEND|TMP_DIR|HYPRLOCK_BG|HYPR_DIR|not_running|are_running|WPB|RANDOM_PICTURE_PATH|mm_options|mm_chosen|TMP_FILE|RANDOM_PICTURE|FREQ"
    unset GET_BACKEND HYPRLAND_PATH WP_BACKENDS WALLPAPER_DIR USE_BACKEND TMP_DIR HYPRLOCK_BG HYPR_DIR not_running are_running WPB RANDOM_PICTURE_PATH mm_options mm_chosen TMP_FILE RANDOM_PICTURE FREQ
    # compgen -v | grep -E "GET_BACKEND|HYPRLAND_PATH|WP_BACKENDS|WALLPAPER_DIR|USE_BACKEND|TMP_DIR|HYPRLOCK_BG|HYPR_DIR|not_running|are_running|WPB|RANDOM_PICTURE_PATH|mm_options|mm_chosen|TMP_FILE|RANDOM_PICTURE|FREQ"

}

usage() {
    echo Usage
}

backend_check() {

    local -a not_running
    local -a are_running

    # check if one of the backends is running; stop/kill it if not the chosen one
    for WPB in "${WP_BACKENDS[@]}"; do
        if ! pgrep -fl "${WPB}"; then
            not_running+=("${WPB//[0-9 ]/}")
        else
            are_running+=("${WPB//[0-9 ]/}")
        fi
    done

    if [[ "${#are_running[@]}" -gt 1 ]]; then
        printf "%s backend(s) is/are running and will be killed\n" "${#are_running[@]}"
        killall "${are_running[@]}"
    fi

    if [[ "${USE_BACKEND}" =~ ${WP_BACKENDS[*]} ]]; then
        if command -v uwsm 1>/dev/null; then
            uwsm app -s b -t service -- "${USE_BACKEND//[0-9 ]/}"
        else
            printf "%s was not found \n" "${USE_BACKEND}"
        fi
    else
        printf "uwsm was not found \n"
    fi
}

make_magick() {

    local -a mm_options
    local -a mm_chosen
    local -a TMP_FILE

    mm_chosen="${1}"

    if [[ ! "${mm_chosen}" =~ ${mm_options[*]} ]]; then
        printf "%s not a valid choice. Setting default %s.\n" "${mm_chosen}" "${mm_options[3]}"
    fi

    TMP_FILE="${TMP_DIR}/background.jpg"

    case "${mm_chosen}" in
    blur)
        magick "${TMP_FILE}" -blur 0x6 "${HYPRLOCK_BG}"
        ;;
    colour)
        magick "${TMP_FILE}" -fill indigo -colorize 40% -virtual-pixel edge "${HYPRLOCK_BG}"
        ;;
    chromablur)
        magick "${TMP_FILE}" -adaptive-blur 0x6 -virtual-pixel edge -channel R -fx p[-10,-24] -channel B -fx p[24,10] "${HYPRLOCK_BG}"
        ;;
    chromargb)
        magick "${TMP_FILE}" -virtual-pixel edge -adaptive-blur 0x6 -channel R -fx p[-10,-24] -channel G -fx p[24,10] -channel B -fx p[24,10] "${HYPRLOCK_BG}"
        ;;
    chroma | *)
        magick "${TMP_FILE}" -virtual-pixel edge -channel R -fx p[-10,-24] -channel B -fx p[24,10] "${HYPRLOCK_BG}"
        ;;
    esac

}

image_generation() {

    local RANDOM_PICTURE_PATH
    # local RANDOM_PICTURE
    # local -i FREQ

    # RANDOM_PICK="$(find "${WALLPAPER_DIR}" -type f | shuf --head-count=1)"
    MONITORS_QTY="$(hyprctl -j monitors | jq --raw-output '.[] .id' | wc --lines)"
    # FREQ=60
    # hyprctl hyprpaper listloaded to list loaded wallpaper
    # rm -v "${HOME}"/.config/hypr/wallpaper.jpg "${HOME}"/.config/hypr/hyprlock-background /tmp/background.jpg "${XDG_RUNTIME_DIR}"/hypr/"${HYPRLAND_INSTANCE_SIGNATURE}"/background.jpg
    # if [[ "${USE_BACKEND}" = hyprpaper ]]; then
    #     hyprctl hyprpaper preload "${RANDOM_PICK}"
    #     hyprctl hyprpaper wallpaper ",${RANDOM_PICK}"
    # else
    #     swww img "${RANDOM_PICK}"
    # fi

    waypaper --backend "${USE_BACKEND/-daemon/}" --restore --random --fill fill --folder "${WALLPAPER_DIR}" | grep --invert-match "We got: en"

    RANDOM_PICTURE_PATH="$(waypaper --list | grep --invert-match "We got: en" | jq --raw-output '.[] .wallpaper')"
    # RANDOM_PICTURE="$(basename "${RANDOM_PICTURE_PATH}")"
    cp --verbose --force "${RANDOM_PICTURE_PATH}" "${TMP_DIR}/background.jpg"
    printf "Wallpaper %s set on %s monitors\n" "${RANDOM_PICTURE_PATH}" "${MONITORS_QTY}"
    cp --verbose --force "${RANDOM_PICTURE_PATH}" "${HYPRLAND_PATH}/background.jpg"

    # For reference, won't be used by waypaper with sww, but was used by my configuration fo hyprpaper
    ln --force --symbolic --verbose "${RANDOM_PICTURE_PATH}" "${HYPR_DIR}/wallpaper.jpg"

    if [[ -L "${HYPRLOCK_BG}" ]]; then
        rm --verbose "${HYPRLOCK_BG}"
    fi

    printf "Generating lockscreen version: %s" "${GET_EFFECT:-chromablur}"
    make_magick "${GET_EFFECT:-chromablur}"
}
# for restoring the wallpapaer when the lid was close and lidhandle is set to "ignore"
post_lid_switch() {
    waypaper --backend "${USE_BACKEND/-daemon/}" --wallpaper "$(waypaper --list | grep -v "We got: en" | jq -r '.[] .wallpaper')"
}

main "${@}"
