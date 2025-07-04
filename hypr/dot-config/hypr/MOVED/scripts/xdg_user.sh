#!/usr/bin/env bash

get_user_dirs() {

    local -a user_dirs
    local udirs_path
    local xdg_dirs_hypr
    local xdg_dirs_uwsm
    local -a artifact_file

    udirs_path="$HOME/.config/user-dirs.dirs"
    xdg_dirs_hypr="$HOME/.config/hypr/conf/xdg_dirs_hypr.conf"
    xdg_dirs_uwsm="$HOME/.config/hypr/conf/xdg_dirs_uwsm.conf"
    artifact_format=(
        "hypr"
        "uwsm"
    )
    xdg_extras=(
        "XDG_UTILS_TERMINAL=${terminal}"
        "XDG_UTILS_BROWSER=${browser}"
        "XDG_UTILS_FILEMANAGER=${fileManager}"
    )

    local -a legacy_env_hyprland
    mapfile -t legacy_env_hyprland < <(grep --invert-match "^#" "${HOME}"/.config/hypr/conf/envs.conf)

    for leh in "${legacy_env_hyprland[@]}"; do
        echo "${leh}"
    done

    if [[ -z ${1} ]]; then
        printf "Use one of: %s" "${artifact_format[*]}"
        exit 1
    fi
    if [[ ! "${1}" =~ ${artifact_file[*]} ]]; then
        printf "Use one of: %s" "${artifact_format[*]}"
        exit 1
    fi
    if [[ -f "${udirs_path}" ]]; then
        mapfile -t user_dirs < <(grep --invert-match --extended-regex "^#" "${udirs_path}")
    else
        printf "%s not found. Can't get your localized user folders (Desktop, Documents etc)\n" "${udirs_path}"
        exit 1
    fi
    if [[ -f "${xdg_dirs_hypr}" ]]; then
        if [[ ! -s "${xdg_dirs_hypr}" ]]; then
            printf "Arquivo %s is empty\n" "${xdg_dirs_hypr}"
        fi
    else

        printf "File %s does not exist. Will be created\n" "${xdg_dirs_hypr}"
        touch "${xdg_dirs_hypr}"

    fi

    local -a uwsm_list
    local -a hypr_list

    case "${1}" in
    uwsm)
        for ud in "${user_dirs[@]}"; do
            uwsm_list+=("${ud//XDG/export XDG}")
        done
        ;;
    hypr)
        for ud in "${user_dirs[@]}"; do
            hypr_list+="$(echo "${ud//XDG/envd = XDG}" | sed --expression='s/\="/,/' --expression='s/"//')"
        done
        ;;
    *)
        printf "Use one of: %s" "${artifact_format[*]}"
        ;;
    esac

    for ul in "${uwsm_list[@]}"; do
        echo "${ul}"
    done
    # echo "${uwsm_list[@]}"
    # echo "${hypr_list[@]}"

}
get_user_dirs "${@}"
