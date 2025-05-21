#!/usr/bin/env bash

nwg_drawer() {

    local SCRIPT_NAME
    local app_name
    local method
    local mode
    local theme
    local primary_path
    local full_parameters
    local search_parameters
    local server_parameters
    local -a modes

    if [[ "${#*}" -gt 3 ]]; then
        echo error
        exit 1
    elif [[ "${#*}" -gt 2 ]]; then
        default_theme="drawer-current.css"
    fi

    SCRIPT_NAME="$(basename "${0}")"
    app_name="nwg-drawer"
    method="${1}"
    mode="${2}"
    theme="${3}"
    primary_path="${HOME}/.config/hypr/nwg"
    common_parameters="-nocats -nofs -k -s ${primary_path}/nwg/${default_theme} -closebtn right -fm ${FILEMANAGER} -wm hyprland"
    full_parameters="${common_parameters} -pbpoweroff \"systemctl poweroff -i\" -pblock \"loginctl lock-session\" -pbreboot \"systemctl reboot -i\" -pbexit \"loginctl terminate-session ${XDG_SESSION_ID}\""
    search_parameters="-nocats -mt 200 -mr 200 -mb 200 -ml 200 ${common_parameters}"
    server_parameters="-r ${full_parameters}"
    modes=(
        "standalone"
        "alone"
        "noserver"
        "normal"
        "open"
        "search"
        "find"
        "server"
        "background"
        "preload"
    )

    if [[ ! ${modes[*]} =~ ${1} ]]; then
        usage
        exit 1
    fi

    if [[ ! ${modes[*]} =~ ${2} ]]; then
        usage
        exit 1
    fi

    if [[ ! "${theme}" == "" ]]; then
        pushd "${primary_path}/" >/dev/null || return
        ln --symbolic --force --verbose "drawer-${theme}.css" "drawer-current.css"
        popd || return
    fi

    case "${method}" in
    # standalone | alone | noserver)
    uwsm)
        # solves problem of not able to use bightness control
        printf "Killing %s\n" "${app_name}"
        killall "${app_name}"
        printf "Starting %s with the theme %s via %s as background graphical\n" "${app_name^}" "${theme}" "${method}"
        case "${mode}" in
        standalone | alone | noserver)
            uwsm app -s a -- nwg-drawer "${full_parameters}"
            ;;
        normal | open)
            uwsm app -s a -- nwg-drawer -open
            ;;
        search | find)
            uwsm app -s a -- nwg-drawer "${search_parameters}"
            ;;
        server | background | preload)
            uwsm app -s a -- nwg-drawer "${server_parameters}"
            ;;
        esac
        ;;
    hyprland)
        # solves problem of not able to use bightness control
        printf "Killing %s\n" "${app_name}"
        killall "${app_name}"
        printf "Starting %s with the theme %s via %s as background graphical\n" "${app_name^}" "${theme}" "${method}"
        case "${mode}" in
        standalone | alone | noserver)
            hyprctl dispatch -- exec nwg-drawer "${full_parameters}"
            ;;
        normal | open)
            hyprctl dispatch -- exec nwg-drawer -open
            ;;
        search | find)
            hyprctl dispatch -- exec nwg-drawer "${search_parameters}"
            ;;
        server)
            hyprctl dispatch -- exec nwg-drawer -r "${full_parameters}"
            ;;
        esac
        ;;
    directly)
        # To reload the configuration without restarting
        printf "Killing %s\n" "${app_name}"
        killall "${app_name}"
        printf "Starting %s with the theme %s via %s as background graphical\n" "${app_name^}" "${theme}" "${method}"
        case "${3}" in
        standalone | alone | noserver)
            nwg-drawer "${full_parameters}"
            ;;
        normal | open)
            nwg-drawer -open
            ;;
        search | find)
            nwg-drawer "${search_parameters}"
            ;;
        server)
            nwg-drawer -r "${full_parameters}"
            ;;
        esac
        ;;
    *)
        usage
        ;;
    esac

}
usage() {
    printf "Usage: %s <method> <mode> <theme>\n" "${SCRIPT_NAME}"
    printf "\t%s\n\t%s\n\t%s\n" "<method>: uwsm, hyprland, directly" "<theme>: name without extension e.g. theme file \"drawer-default.css\" so will be \"default\". I will be used for both files json/jsonc and css if any." "<mode>: [standalone | alone | noserver] [normal | open] [search | find] server"
    printf "Not passing a configuration name for %s, will make it fallback to the defaults: config.jsonc and style.css" "${SCRIPT_NAME}"
}
nwg_drawer "${@}"
