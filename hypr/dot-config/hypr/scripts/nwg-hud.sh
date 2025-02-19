#!/usr/bin/env bash
# IDEAS
# use hud combining with a keybind to show what is opened inside that workspace
# something like

highlander() {
	local -a only_one
	# only_one="$(ps -eo cmd= | grep nwg-hud.sh | grep -vE "grep" | sed 's/bash //g')"
	mapfile -t only_one < <(pgrep -f "${SCRIPT_NAME}")

	for oo in "${only_one[@]}"; do
		printf "nwg-hud.sh PID: %s\n" "${oo}"
	done

	printf "Killing all process of %s\n" "${SCRIPT_NAME}"
}

workspace_hud() {

	local -a workspace_types
	local -i TIMEOUT
	local workspace_name
	local float_state
	local -i qtd

	workspace_types=(
		"workspace>>"
		"activespecial>>"
	)
	submap="submap>>"
	TIMEOUT=1000
	float_state="changefloatingmode>>"

	if [[ ${1:0:11} == "${workspace_types[0]}" ]]; then

		nwg-hud -t "${TIMEOUT}" -m "  Workspace ${1//[^[:digit:]]/}"

	elif [[ ${1:0:15} == "${workspace_types[1]}" ]]; then

		workspace_name="$(printf "%s" "${1}" | xargs -0 | grep -Po "(?<=:)(.*?)(?=,)")"

		if [[ ${workspace_name} == "" ]]; then
			nwg-hud -t "${TIMEOUT}" -m "  Workspace ${1//[^[:digit:]]/}"
		else
			nwg-hud -t "${TIMEOUT}" -m "  Workspace ${workspace_name}"
		fi

	elif [[ "${1}" =~ ${submap} ]]; then

		nwg-hud -t "${TIMEOUT}" -m "󰙖  Submap: ${1:8}" -va bottom

	elif [[ "${1}" =~ ${float_state} ]]; then

		qtd="$(( ${#1} - 1 ))"
		echo "qtd: $qtd float: ${1:$qtd:1}"
		[[ "${1:$qtd:1}" -eq 0 ]] && fs="Tiling" || fs="Floating"
		nwg-hud -t "${TIMEOUT}" -m "󰙖  ${fs}" -va bottom

	else

		printf "%s\n" "Nothing to do."

	fi

}
main() {

	local HYPRLAND_PATH
	local LOCKFD
	local SCRIPT_NAME
	local SCRIPT_FOLDER
	local LOCKFILE
	local LOCKFILE
	local LOCKFD

	HYPRLAND_PATH="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}"
	SCRIPT_NAME="$(basename "${0}")"
	SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	# Lock File method from https://stackoverflow.com/a/1985512/473433
	LOCKFILE="${HYPRLAND_PATH}/$(basename "${0}").lock"
	LOCKFD=99

	# Remember! Lock file is removed when one of the scripts exits and it is
	#           the only script holding the lock or lock is not acquired at all.
	# -u, --unlock
	# Drop a lock. This is usually not required, since a lock is automatically dropped when the file
	# is closed. However, it may be required in special cases, for example if the enclosed command
	# group may have forked a background process which should not be holding the lock.
	# -n, --nb, --nonblock
	# Fail rather than wait if the lock cannot be immediately acquired. See the -E option for the
	# exit status used.
	# -e, -x, --exclusive
	# Obtain an exclusive lock, sometimes called a write lock. This is the default.
	# -s, --shared
	# Obtain a shared lock, sometimes called a read lock.

	# PRIVATE
	_lock() { flock -"${1}" "${LOCKFD}"; }
	_no_more_locking() {
		_lock u
		_lock xn && rm -f "${LOCKFILE}"
		printf "%s already running or lock file couldn't be removed" "${SCRIPT_NAME}"
	}
	_prepare_locking() {
		eval "exec ${LOCKFD}>\"${LOCKFILE}\""
		trap _no_more_locking EXIT
	}
	exlock_now() { _lock xn; } # obtain an exclusive lock immediately or fail
	exlock() { _lock x; }      # obtain an exclusive lock
	shlock() { _lock s; }      # obtain a shared lock
	unlock() { _lock u; }      # drop a lock

	# Lock file
	_prepare_locking
	# Simplest example is avoiding running multiple instances of script.
	exlock_now || exit 1
	# Remember! Lock file is removed when one of the scripts exits and it is
	# End of Lock file method

	# Monitor Hyprland's Socket 2
	socat -U - "UNIX-CONNECT:${HYPRLAND_PATH}/.socket2.sock" | while read -r line; do workspace_hud "${line}"; done
}
main "${@}"
