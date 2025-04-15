#!/usr/bin/env bash

main() {

    local -a KEY_HOURS
    local SCRIPT_NAME
    # local SCRIPT_FOLDER
    SCRIPT_NAME="$(basename "${0}")"
    # SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    KEY_HOURS=(
        "7"
        "12"
        "17"
        "21"
        "23"
    )

    # check_filter
    # hyprsunset_gradual "${@}"
    # set_timer "${@}"
    gradually
}

gradually() {

    local -i i
    local -i cur_temp
    local -i tar_temp

    cur_temp="$(pgrep --list-full hyprsunset | cut --delimiter=" " --fields=4)"
    tar_temp="7500"
    i="${cur_temp}"

    while [ "${i}" -le "${tar_temp}" ]; do
        pkill hyprsunset
        printf "Setting to %s\n" "${i}"
        echo hyprsunset --temperature "${i}"
        # disown
        ((i += 500))
        sleep 0.1s
    done
}

check_filter() {

    local blue_blocker
    blue_blocker="hyprsunset"

    if command -v "${blue_blocker}"; then
        printf "Blue light blocker %s found. Proceeding.\n" "${blue_blocker}"
    else
        exit 1
    fi
}

hyprsunset_gradual() {

    # for kh in "${KEY_HOURS[@]}"; do
    #     printf "%s\n" "${kh}"
    # done

    # for kh in "${KEY_HOURS[@]}"; do
    #     on_calendar+=("OnCalendar=*-*-* ${kh}:00:00\n")
    # done

    # echo -e "${on_calendar[*]}"

    HOUR=$(date '+%H')

    case "${HOUR}" in
    "7")
        for ((i = 0; i < 7500; i += 500)); do
            killall hyprsunset
            hyprsunset --temperature 7500
        done
        ;;
    "16")
        killall hyprsunset
        hyprsunset --temperature 6500
        ;;
    "18")
        killall hyprsunset
        hyprsunset --temperature 5000
        ;;
    "21")
        killall hyprsunset
        hyprsunset --temperature 4500
        ;;
    "23")
        killall hyprsunset
        hyprsunset --temperature 3000
        ;;
    esac

}

set_timer() {

    # Save these files as ~/.config/systemd/user/some-service-name.*
    # Run this now and after any modifications: systemctl --user daemon-reload
    # Try out the service (oneshot): systemctl --user start some-service-name
    # Check logs if something is wrong: journalctl -u --user-unit some-service-name
    # Start the timer after this user logs in: systemctl --user enable --now some-service-name.timer
    # local when_to_run
    local timer_file
    local service_file

    for kh in "${KEY_HOURS[@]}"; do
        # DayOfWeek Year-Month-Day Hour:Minute:Second
        # when_to_run="*-*-* ${kh}:00:00"
        on_calendar+=("OnCalendar=*-*-* ${kh}:00:00\n")
    done
    teste="${on_calendar[*]}"
    timer_file="[Unit]
Description=Changes blue light filter levels during the day

[Timer]
OnBootSec=10min
OnUnitActiveSec=1w
${teste}

[Install]
WantedBy=timers.target
"
    printf "%b" "${timer_file}"

    service_file="[Unit]
Description=Changes blue light filter levels during the day
After=network.target
[Service]
Type=oneshot
ExecStart=notify-send --urgency=normal \"Blue light script\" \"this is set by the blue_light.sh script\"
[Install]
WantedBy=multi-user.target
"
    printf "%b" "${timer_file}" | tee "${HOME}/.config/systemd/user/${SCRIPT_NAME}.timer"
    printf "%b" "${service_file}" | tee "${HOME}/.config/systemd/user/${SCRIPT_NAME}.service"
    systemctl --user enable --now "${HOME}/.config/systemd/user/${SCRIPT_NAME}.timer"

}

del_timer() {

    echo mv -v "${HOME}/.config/systemd/user/${SCRIPT_NAME}.timer" "/tmp/protongettemp/"
    echo mv -v "${HOME}/.config/systemd/user/${SCRIPT_NAME}.service" "/tmp/protongettemp/"
}
main "${@}"
