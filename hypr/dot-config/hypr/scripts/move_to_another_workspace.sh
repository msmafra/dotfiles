#!/usr/bin/env bash

funcao() {
    local current_workspace
    local current_monitor
    local -a windows_list
    local moving_tag

    current_workspace="$(hyprctl -j activeworkspace | jq -r '.id')" # hyprctl activeworkspace | awk -F' ' 'NR==1 {print $3}'
    current_monitor="$(hyprctl -j activeworkspace | jq -r '.monitorID')" # hyprctl activeworkspace | awk -F' ' 'NR==1 {print $3}'
    mapfile -t windows_list < <(hyprctl clients -j | jq -r '.[] | select(.workspace.id == 7) | .address')
    count_monitors="$(hyprctl -j monitors | jq -r '.[] .id')"

    # for wl in "${windows_list[@]}";do
    # echo "$wl"
    # done

    # echo "${#windows_list[@]}"
    # echo "${!windows_list[@]}"
    # echo "${windows_list[@]}"
    # echo "${windows_list[*]}"
    moving_tag="movedFromWorkspace${current_workspace}"

    if [[ "${#windows_list[@]}" -lt 1 ]]; then
        printf "the workspace is empty (mon %s)" "${current_monitor}"
    else
        printf "%b are windows current in workspace #%s" "${windows_list[*]}" "${current_workspace}"
    fi



}
funcao
