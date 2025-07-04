#!/usr/bin/env bash

new_themed_icons() {
    local original_file
    local original_color
    local target_color
    local new_file

    #'rgb(160,186,241)'
    #'rgb(253, 139, 81)'

    if [[ "${#*}" == 4 ]]; then
        original_file="${1}"
        shift
        original_color="${1}"
        shift
        target_color="${1}"
        shift
        new_file="${1}"
        shift

        echo magick "${original_file}" -fuzz 0% -fill "${original_color}" -opaque "${target_color}" "${new_file}"
    else
        echo "Usage:"
        echo "4 arguments are required: original file, original color, target color and new file"
        echo "magick <original_file> -fuzz 0% -fill <original_color> -opaque <target_color> <new_file>"
    fi
}
new_themed_icons "${@}"
