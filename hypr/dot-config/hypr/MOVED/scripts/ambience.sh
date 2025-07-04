#!/usr/bin/env bash
# inspired by https://johnnymatthews.dev/blog/2021-05-14-random-wallpaper-script/
# Randomizes wallpapers and generates an copy with effects for screen lockers.
# Background images hyprpaper or sww and apply a effects to its copy for use with hyprlock.
# maybe, if gnome-based system copy the user avatar /var/lib/AccountsService/icons/$USER and
# also apply the effects on it
main() {
    # local GET_BACKEND
    # local HYPRLAND_PATH
    local -a WP_BACKENDS
    # local WALLPAPER_DIR
    local USE_BACKEND
    local TMP_DIR
    local -g LOCK_SCREEN_BG
    local -g BACKDROP
    local -g WALLPAPER
    local WM_SHARE_DIR
    local WAYPAPER_FILE
    local -g TMP_LOCK_IMG
    local -g TMP_DROP_IMG
    local -g TMP_WALL_IMG

    WM_SHARE_DIR="${XDG_CACHE_HOME}/compositors-shared"
    WAYPAPER_FILE="$WM_SHARE_DIR/waypaper.ini"
    LOCK_SCREEN_BG="${WM_SHARE_DIR}/lock-screen-image"
    BACKDROP="${WM_SHARE_DIR}/backdrop-image"
    WALLPAPER="${WM_SHARE_DIR}/wallpaper-image"
    GET_EFFECT="${1}"
    # HYPRLAND_PATH="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}"
    # WP_BACKENDS=( # The first item in the array is the default. Change the order to use another one
    #     "swaybg"
    #     "swww-daemon"
    #     "hyprpaper"
    # )
    WALLPAPER_DIR="${XDG_PICTURES_DIR}/Wallpapers"
    TMP_DIR="/tmp"
    USE_BACKEND="swww"

    mkdir -pv "${WM_SHARE_DIR}"
    # if [[ ! "${GET_BACKEND}" =~ ${WP_BACKENDS[*]} ]]; then
    #     USE_BACKEND="${WP_BACKENDS[0]}"
    #     printf "Backend not chosen or invalid (options: %s). Using default: %s\n" "${WP_BACKENDS[*]}" "${WP_BACKENDS[0]}"
    # else
    #     USE_BACKEND="${GET_BACKEND}"
    # fi

    # backend_check "${@}"
    images_generation "${@}"
    # set gtk flatpaks darkmode
    #doas flatpak override --env=GTK_THEME=Adwaita-dark
    unset GET_BACKEND HYPRLAND_PATH WP_BACKENDS WALLPAPER_DIR USE_BACKEND TMP_DIR LOCK_SCREEN_BG WM_SHARE_DIR not_running are_running WPB RANDOM_LOCK_SCREEN_PICTURE mm_options mm_chosen TMP_FILE RANDOM_PICTURE FREQ

}

usage() {
    echo "Usage not created yet"
}

backend_check() {

    local -a not_running
    local -a are_running
    local -a current_backend

    current_backend="$(grep -Eo "${USE_BACKEND}" "${WAYPAPER_FILE}")"
    if [[ "${current_backend}" == "${USE_BACKEND}" ]]; then
        printf "Current backend in %s file is set to %s" "${WAYPAPER_FILE}" "${current_backend}"
    else
        printf "Currently backend in %s file is set to %s.\nChanging to the new default %s..." "${WAYPAPER_FILE}" "${current_backend}" "${USE_BACKEND}"
        sed -i "s/${current_backend}/backend = ${USE_BACKEND}/g" "${WAYPAPER_FILE}"
    fi

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
    # local -a TMP_FILE

    mm_chosen="${1}"
    if [[ ! "${mm_chosen}" =~ ${mm_options[*]} ]]; then
        printf "%s not a valid choice. Setting default %s.\n" "${mm_chosen}" "${mm_options[3]}"
    fi
    # TMP_FILE="${TMP_DIR}/lock-screen-image.jpg"

    case "${mm_chosen}" in
    blur)
        magick "${TMP_LOCK_IMG}" -blur 0x6 "${LOCK_SCREEN_BG}"
        ;;
    colour)
        magick "${TMP_LOCK_IMG}" -fill indigo -colorize 40% -virtual-pixel edge "${LOCK_SCREEN_BG}"
        ;;
    chromablur)
        magick "${TMP_LOCK_IMG}" -adaptive-blur 0x6 -virtual-pixel edge -channel R -fx p[-10,-24] -channel B -fx p[24,10] "${LOCK_SCREEN_BG}"
        ;;
    chromargb)
        magick "${TMP_LOCK_IMG}" -virtual-pixel edge -adaptive-blur 0x6 -channel R -fx p[-10,-24] -channel G -fx p[24,10] -channel B -fx p[24,10] "${LOCK_SCREEN_BG}"
        ;;
    chroma | *)
        magick "${TMP_LOCK_IMG}" -virtual-pixel edge -channel R -fx p[-10,-24] -channel B -fx p[24,10] "${LOCK_SCREEN_BG}"
        ;;
    esac

}

images_generation() {

    local RANDOM_LOCK_SCREEN_PICTURE
    if [[ "${XDG_CURRENT_DESKTOP}" == "niri" ]]; then
        MONITORS_QTY="$(niri msg outputs | grep --count "Output")"
    else
        MONITORS_QTY="$(hyprctl -j monitors | jq --raw-output '.[] .id' | wc --lines)"
    fi
    TMP_LOCK_IMG="${TMP_DIR}/lock-screen-image.jpg"
    TMP_DROP_IMG="${TMP_DIR}/backdrop-image.jpg"
    TMP_WALL_IMG="${TMP_DIR}/wallpaper-image.jpg"
    RANDOM_LOCK_SCREEN_PICTURE="$(find "${WALLPAPER_DIR}" -type f | shuf --head-count=1)"
    RANDOM_BACKDROP_PICTURE="$(find "${WALLPAPER_DIR}" -type f | shuf --head-count=1)"
    RANDOM_WALLPAPER_PICTURE="$(find "${WALLPAPER_DIR}" -type f | shuf --head-count=1)"

    cp --verbose --force "${RANDOM_LOCK_SCREEN_PICTURE}" "${TMP_LOCK_IMG}"
    cp --verbose --force "${RANDOM_BACKDROP_PICTURE}" "${TMP_DROP_IMG}"
    cp --verbose --force "${RANDOM_WALLPAPER_PICTURE}" "${TMP_WALL_IMG}"

    # ln --force --symbolic --verbose "${RANDOM_LOCK_SCREEN_PICTURE}" "${LOCK_SCREEN_BG}"
    # ln --force --symbolic --verbose "${RANDOM_BACKDROP_PICTURE}" "${BACKDROP}"
    # ln --force --symbolic --verbose "${RANDOM_WALLPAPER_PICTURE}" "${WALLPAPER}"
    printf "Copying backdrop image version: %s\n" "${BACKDROP}"
    cp --verbose --force "${TMP_DROP_IMG}" "${BACKDROP}"

    printf "Wallpaper %s set on %s monitors\n" "${WALLPAPER}" "${MONITORS_QTY}"
    cp --verbose --force "${TMP_WALL_IMG}" "${WALLPAPER}"

    printf "Copying lock screen image: %s\n" "${LOCK_SCREEN_BG}"
    cp --verbose --force "${TMP_LOCK_IMG}" "${LOCK_SCREEN_BG}"

    printf "Generating lockscreen with effects: %s\n" "${GET_EFFECT:-chromablur}"
    make_magick "${GET_EFFECT:-chromablur}"

    swww kill
    swww clear-cache
    swww-daemon &
    disown
    swww img "${WALLPAPER}"
    swaybg --image "${BACKDROP}" &
    disown
    # if [[ -L "${LOCK_SCREEN_BG}" ]]; then
    #     rm --verbose "${LOCK_SCREEN_BG}"
    # fi

}
# for restoring the wallpapaer when the lid was close and lidhandle is set to "ignore"
post_lid_switch() {
    waypaper --backend "${USE_BACKEND/-daemon/}" --wallpaper "$(waypaper --list | grep -v "We got: en" | jq -r '.[] .wallpaper')"
}

main "${@}"
