#!/usr/bin/env bash
# IDEAS
# use hud combining with a keybind to show what is opened inside that workspace
# something like
#{{{ Bash settings
set -o errexit
set -o nounset
set -o pipefail
set -o errtrace
#}}}
#######################################
# Runs everything
#######################################
main() {

    local HYPRLAND_PATH
    local LOCKFD
    local SCRIPT_NAME
    local SCRIPT_FOLDER
    local LOCKFILE
    local -i TIMEOUT

    HYPRLAND_PATH="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}"
    LOCKFD=99
    SCRIPT_NAME="$(basename "${0}")"
    SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # Lock File method from https://stackoverflow.com/a/1985512/473433
    LOCKFILE="${HYPRLAND_PATH}/$(basename "${0}").lock"
    TIMEOUT=1000

    printf "Initializing %s/%s\n" "${SCRIPT_FOLDER}" "${SCRIPT_NAME}"
    # Simplest example is avoiding running multiple instances of script.
    # Lock file
    _prepare_locking "${@}"
    exlock_now || exit 1
    # End of Lock file method
    # Monitor Hyprland's Socket 2
    while read -r line; do
        workspace_hud "${line}"
    done < <(socat -U - "UNIX-CONNECT:${HYPRLAND_PATH}/.socket2.sock")
    # socat -U - "UNIX-CONNECT:${HYPRLAND_PATH}/.socket2.sock" | while read -r line; do workspace_hud "${line}"; done
}
#######################################
# There can be only one
#######################################
highlander() {
    local -a only_one
    # only_one="$(ps -eo cmd= | grep nwg-hud.sh | grep -vE "grep" | sed 's/bash //g')"
    mapfile -t only_one < <(pgrep --full "${SCRIPT_NAME}")

    for oo in "${only_one[@]}"; do
        printf "nwg-hud.sh PID: %s\n" "${oo}"
    done

    printf "Killing all process of %s\n" "${SCRIPT_NAME}"
}
#######################################
# Workspaces name and ID
#######################################
workspace_hud() {

    local -a workspace_types
    local workspace_name

    workspace_types=(
        "workspace>>"
        "activespecial>>"
    )

    if [[ "${1:0:11}" = "${workspace_types[0]}" ]]; then
        nwg-hud -t "${TIMEOUT}" -ha left -m "  Workspace ${1//[^[:digit:]]/}" &
        hyprctl notify 1 "${TIMEOUT}" "rgb(ff1ea3)" "fontsize:32   Workspace ${1//[^[:digit:]]/}" &
    elif [[ "${1:0:15}" = "${workspace_types[1]}" ]]; then
        workspace_name="$(printf "%s" "${1}" | xargs --null | grep --perl-regexp --only-matching "(?<=:)(.*?)(?=,)")"
        if [[ "${workspace_name}" == "" ]]; then
            nwg-hud -t "${TIMEOUT}" -ha left -m "  Workspace ${1//[^[:digit:]]/}" &
            hyprctl notify 1 "${TIMEOUT}" "rgb(ff1ea3)" "fontsize:32   Workspace ${1//[^[:digit:]]/}" &
        else
            nwg-hud -t "${TIMEOUT}" -ha left -m "  Workspace ${workspace_name}" &
            hyprctl notify 1 "${TIMEOUT}" "rgb(ff1ea3)" "fontsize:32   Workspace ${workspace_name}" &
        fi
    else
        printf "%s\n" "Nothing to do."
    fi
}
#######################################
# Get/show window state
#######################################
show_float_state() {
    local float_state
    local -i qtd
    float_state="changefloatingmode>>"

    if [[ "${1}" =~ ${float_state} ]]; then
        qtd="$((${#1} - 1))"
        printf "qtd: %s float: %s" "$qtd" "${1:$qtd:1}\n"
        [[ "${1:$qtd:1}" -eq 0 ]] && fs="Tiling" || fs="Floating"
        nwg-hud -t "${TIMEOUT}" -m "󰙖  ${fs}" -va bottom
    else
        printf "%s\n" "Nothing to do."
    fi
}
#######################################
# Show if and what submap is active
#######################################
show_submap() {
    local submap
    submap="submap>>"
    if [[ "${1}" =~ ${submap} ]]; then
        nwg-hud -t "${TIMEOUT}" -m "󰙖  Submap: ${1:8}" -va bottom
    else
        printf "%s\n" "Nothing to do."
    fi
}
# Start file lock solution by przemoc
# https://stackoverflow.com/questions/1715137/what-is-the-best-way-to-ensure-only-one-instance-of-a-bash-script-is-running/1985512
# PRIVATE
_lock() {
    echo flock -"${1}" "${LOCKFD:-}"
    flock -"${1}" "${LOCKFD:-}"
}
_no_more_locking() {
    _lock u
    _lock xn && rm --force "${LOCKFILE:-}"
    printf "%s already running or lock file couldn't be removed" "${SCRIPT_NAME}"
}
_prepare_locking() {
    eval "exec ${LOCKFD:-}>\"${LOCKFILE:-}\""
    trap _no_more_locking EXIT
}
# obtain an exclusive lock immediately or fail
exlock_now() {
    _lock xn
}
# obtain an exclusive lock
exlock() {
    _lock x
}
# obtain a shared lock
shlock() {
    _lock s
}
# drop a lock
unlock() {
    _lock u
}
# End file lock solution
# Run it
main "${@}"
