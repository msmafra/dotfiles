#!/usr/bin/env bash
main() {
    local action
    local get_session_id
    action="${*}"
    # get_session_id="$(loginctl list-sessions | awk 'NR==2{print $1}')"
    get_session_id="${XDG_SESSION_ID}"

    if [[ ! "${action}" = "" ]]; then
        case ${action} in
        lock)
            lock_session
            ;;
        logoff)
            logoff_gracefully
            ;;
        poweroff)
            poweroff_gracefully
            ;;
        reboot)
            logoff_gracefully
            ;;
        suspend | sleep)
            logoff_gracefully
            ;;
        *)
            printf "This script does not recognize: %s. \n Use: lock, logoff, poweroff, reboot or sleep/suspend" "${action}"
            ;;
        esac
    fi
}
lock_session() {
    loginctl lock-session
}
logoff_gracefully() {
    if ! command -v uwsm; then
        uwsm stop -r
    else
        loginctl terminate-session "${get_session_id}"
    fi
}
poweroff() {
    systemctl poweroff --check-inhibitors=yes
}
reboot() {
    systemctl reboot --check-inhibitors=yes
}
suspend() {
    systemctl reboot --check-inhibitors=yes
}
main "${@}"
