#!/usr/bin/env bash
#taken from man logind.conf
#           logind.conf, logind.conf.d - Login manager configuration files
#
#        SYNOPSIS
#                   /etc/systemd/logind.conf
#                   /run/systemd/logind.conf
#                   /usr/local/lib/systemd/logind.conf
#                   /usr/lib/systemd/logind.conf
#                   /etc/systemd/logind.conf.d/*.conf
#                   /run/systemd/logind.conf.d/*.conf
#                   /usr/local/lib/systemd/logind.conf.d/*.conf
#                   /usr/lib/systemd/logind.conf.d/*.conf
main() {
    local -g LID_PATH
    LID_PATH="/etc/systemd/logind.conf.d"
    local -g LID_FILE
    LID_FILE_PATH="60-logind-lid-switch.conf"

    check_all_places
}
check_logind_conf() {

    if [[ -d "${LID_FILE_PATH}" ]]; then
        printf
    fi

}

check_all_places() {

    local -a logind_files_paths
    local -a logind_directories_paths
    local -a lfp_dne
    local -a lfd_dne

    logind_files_paths=(
        "/etc/systemd/logind.conf"
        "/run/systemd/logind.conf"
        "/usr/local/lib/systemd/logind.conf"
        "/usr/lib/systemd/logind.conf"
    )
    logind_directories_paths=(
        "/etc/systemd/logind.conf.d/"
        "/run/systemd/logind.conf.d/"
        "/usr/local/lib/systemd/logind.conf.d/"
        "/usr/lib/systemd/logind.conf.d/"
    )

    for lfp in "${logind_files_paths[@]}"; do
        if [[ -d "${lfp}" ]]; then
            printf "File \"%s\" exists.\n" "${lfp}"
        else
            printf "File \"%s\" doesn't exists.\n" "${lfp}"
            lfp_dne+=("${lftp}")
        fi
    done
    for ldp in "${logind_directories_paths[@]}"; do
        if [[ -d "${ldp}" ]]; then
            printf "File \"%s\" exists.\n" "${ldp}"
        else
            printf "File \"%s\" doesn't exists.\n" "${ldp}"
            lfd_dne+=("${ldp}")
        fi
    done

    if [[ "${#lfp_dne[@]}" -eq "${#logind_files_paths[@]}" ]]; then
        printf "%s\n" "No logind.conf files found."
    fi
    if [[ "${#lfd_dne[@]}" -eq "${#logind_directories_paths[@]}" ]]; then
        printf "%s\n" "No logind.conf.d directories found."
    fi

}
set_lid_no_suspend() {

    local lid_switch_ignore
    local logind_service
    lid_switch_ignore="
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
"
    logind_service="systemd-logind.service"
    # from https://discussion.fedoraproject.org/t/fedora-server-40-issue-preventing-suspend-on-lid-close/119185/2
    printf "%b" "${lid_switch_ignore}" | sudo tee "${LID_FILE_PATH}" >/dev/null
    sudo restorecon -F -R /etc/systemd
    printf "Reloading %s." "${logind_service}"
    sudo systemctl reload "${logind_service}"
    printf "%s reloaded. Close the lid to test it.\nIf it doesn't work, run systemctl restart %s \n-- IT WILL END YOU CURRENT SESSION -- \nor restart the system." "${logind_service}" "${logind_service}"
}

main "${@}"
