#!/usr/bin/env bash
# Script to use hyprshot and satty to take sscreen captures
# without having giant lines inside Hyprland files
# bindd = , PRINT, Screen capture with hyprshot clicking on the desired monitor to choose, exec,
# # # hyprshot --raw --mode output --clipboard-only; wl-paste | satty -f - --copy-command wl-copy --action-on-enter save-to-file --corner-roundness 0 --output-filename "$XDG_PICTURES_DIR/Screenshots/Screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"
# bindd = $mainMod, PRINT, Screen capture a window with hyprshot + satty, exec,
# # # hyprshot --raw --mode window --clipboard-only; wl-paste | satty -f - --copy-command wl-copy --action-on-enter save-to-file --corner-roundness 0 --output-filename "$XDG_PICTURES_DIR/Screenshots/Screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"
# bindd = $mainMod SHIFT, PRINT, Screen capture a region with hyprshot + satty, exec,
# # # hyprshot --raw --mode region --clipboard-only; wl-paste | satty -f - --copy-command wl-copy --action-on-enter save-to-file --corner-roundness 0 --output-filename "$XDG_PICTURES_DIR/Screenshots/Screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"
take_it() {
    local method
    local file_name
    local dest_dir
    local dest_file
    local -a accepted

    method="${*}"
    dest_dir="$XDG_PICTURES_DIR/Screenshots"
    unset file_name
    file_name="Screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"
    dest_file="${dest_dir}/${file_name}"
    accepted=(
        "region"
        "screen"
        "quick"
        "window"
    )

    # echo "
    # $method
    # $dest_dir
    # $dest_file
    # $file_name
    # ${accepted[*]}
    # "
    # exit 1
    # hyprshot -m window -m active --clipboard-only
    # wl-paste | satty -f - --copy-command wl-copy -o "$XDG_PICTURES_DIR/Screenshots/Screenshot-$(date '+%Y-%m-%d-%H-%M-%S')".png
    # PrtSc for whole screen
    # Crtl + PrtSc for current window
    # Shift + PrtSc for area of the screen, which then automatically saves the screenshot to a file in the home directory.

    if [[ "${#method[*]}" -eq 1 ]]; then
        case "${method}" in
        screen)
            # Printscreen
            hyprshot --raw --mode output | satty -f - --copy-command wl-copy --output-filename "$dest_file"
            notify-send --urgency=normal "Screen Captured" "Should be save to $dest_file"
            ;;
        window)
            # Ctrl + Printscreen
            hyprshot --raw --mode window | satty -f - --copy-command wl-copy --action-on-enter save-to-file --corner-roundness 0 --output-filename "${dest_file}"
            notify-send --urgency=normal "Window Captured" "Should be save to ${dest_file}"
            ;;
        region)
            # Shift + Printscreen
            hyprshot --raw --mode region | satty -f - --copy-command wl-copy --action-on-enter save-to-file --corner-roundness 0 --output-filename "${dest_file}"
            notify-send --urgency=normal "Region Captured" "Should be save to ${dest_file}"
            ;;
        quick)
            # Super + Ctrl + Printscreen
            hyprshot --raw --mode active --mode window
            notify-send --urgency=normal "Active window Captured" "Should be save to ${dest_file}"
            ;;
        *)
            # Super + Shift + Printscreen
            hyprshot --raw --mode active --mode output
            notify-send --urgency=normal "Active screen Captured" "Should be save to ${dest_file}"
            ;;
        esac
    else
        printf "Accepted parameters %s\n" "${accepted[*]}"
    fi
}
take_it "${@}"
