#!/usr/bin/env bash
# https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#alt-tab-behaviour

main() {

    local -a commands
    local command
    commands=(
        "alttab"
        "disable"
        "preview"
    )
    command="${1}"

    if [[ ! "${*}" =~ ${commands[*]} ]]; then
        printf "%s\n" "${commands[*]}"
    fi

    case "${command}" in
    "alttab")
        alttab_it
        ;;
    "disable")
        disable_it
        ;;
    "preview")
        preview_it "${@}"
        ;;
    esac

}

alttab_it() {
    address=$(hyprctl -j clients | jq -r 'sort_by(.focusHistoryID) | .[] | select(.workspace.id >= 0) | "\(.address)\t\(.title)"' |
        fzf --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red \
            --cycle \
            --sync \
            --bind tab:down,shift-tab:up,start:down,double-click:ignore \
            --wrap \
            --delimiter=$'\t' \
            --with-nth=2 \
            --preview "${XDG_CONFIG_HOME}/scripts/alttab.sh preview {}" \
            --preview-window=down:80% \
            --layout=reverse |
        awk -F"\t" '{print $1}')

    if [ -n "${address}" ]; then
        hyprctl --batch -q "dispatch focuswindow address:${address} ; dispatch alterzorder top"
    fi

    hyprctl -q dispatch submap reset
}

preview_it() {
    shift
    line="$1"

    IFS=$'\t' read -r addr _ <<<"${line}"
    dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}

    grim -t png -l 0 -w "${addr}" ~/scripts/alttab_preview.png
    chafa --animate false -s "${dim}" "${XDG_CONFIG_HOME}/scripts/alttab_preview.png"
}

disable_it() {

    hyprctl -q keyword animations:enabled true
    hyprctl -q keyword unbind "ALT, tab"
    hyprctl -q keyword bind ALT, tab, exec, "hyprctl -q keyword animations:enabled false ; hyprctl -q dispatch exec 'footclient -a alttab ${XDG_CONFIG_HOME}/scripts/alttab.sh' ; hyprctl -q keyword unbind 'ALT, tab' ; hyprctl -q dispatch submap alttab"
}
main "${@}"
