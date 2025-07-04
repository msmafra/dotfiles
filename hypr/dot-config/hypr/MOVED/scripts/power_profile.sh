#!/usr/bin/env bash

# main {

# local handler

# handler="$(get_handler)"

# }

get_handler() {
	local -a handlers_opt

	handlers_opt=(
		"powerprofilesctl"
		"tuned-adm"
	)

	if command -v powerprofilesctl; then

		printf "%s" "${handlers_opt[1]}"
	else
		printf "%s" "${handlers_opt[2]}"
	fi
	for ho in "${handlers_opt[@]}"; do
		echo $ho
	done

}
# main "${@}"
get_handler
