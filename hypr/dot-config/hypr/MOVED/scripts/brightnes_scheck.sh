#!/usr/bin/env bash

get_brightness() {

    local -a GB
    local -a NEW
    mapfile -n 20 -t GB < <(find ~/Imagens/Wallpapers -name "*.jpg")
    i=1
    for gb in "${GB[@]}"; do
        new="$(magick "${gb}" -colorspace HSI -channel b -separate +channel -scale 1x1 -format "%[fx:100*u]\n" info:)"
        NEW+=("${new//[a-zA-Z-.]/}")
    done

    echo "${NEW[*]}"

}
get_brightness
