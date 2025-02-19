#!/usr/bin/env bash

# https://johnnymatthews.dev/blog/2021-05-14-random-wallpaper-script/
# randomizes background images for hyprlock and hyprpaper. for hyprlock it applies effects
main() {
	local GET_BACKEND
	local HYPRLAND_PATH
	local -a WP_BACKENDS
	local WALLPAPER_DIR
	local USE_BACKEND

	GET_BACKEND="${1}"
	HYPRLAND_PATH="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}"
	WP_BACKENDS=(
		"hyprpaper"
		"swww-daemon"
	)
	WALLPAPER_DIR="${HOME}/Imagens/Wallpapers"
	if [[ ! "${GET_BACKEND}" =~ ${WP_BACKENDS[*]} ]]; then
		printf "Backend not chosen or invalid (options: %s). Using default: %s\n" "${WP_BACKENDS[*]}" "${WP_BACKENDS[0]}"
		USE_BACKEND="${WP_BACKENDS[0]}"
	else
		USE_BACKEND="${GET_BACKEND}"
	fi
	backend_check "${@}"
	make_magick chroma

}

backend_check() {

	# check if one of the backends is running; stop/kill it if not the chosen one
	for WPB in "${WP_BACKENDS[@]}"; do
		if ! pgrep -fl "${WPB}"; then
			printf "Not running %s\n" "${WPB//[0-9 ]/}"
		fi
	done

	# systemctl show enabled/disabled abd also returns error status 0/1 (0 = enabled 1 = disabled)
	case "${USE_BACKEND}" in
	"${WP_BACKENDS[0]}")
		uwsm app -s b -t service -- "${USE_BACKEND}"
		# if systemctl --user is-active hyprpaper.service;then
		# if systemctl --user is-enabled hyprpaper.service; then

		# 	# systemctl --user enable --now hyprpaper.service
		# 	systemctl --user start hyprpaper.service
		# fi
		# fi
		;;
	*)
		if command -v uwsm; then
			if command -v swww-daemon; then
				uwsm app -s b -t service -- "${USE_BACKEND}"
			else
				printf "%s was not found \n" "${USE_BACKEND}"
				exit 1
			fi
		else
			printf "%s was not found\n" "${USE_BACKEND}"
			exit 1
		fi
		;;
	esac

}

make_magick() {

	local -a mm_options
	local -a mm_chosen
	local -a TMP_FILE

	mm_options=(
		"blur"
		"colour"
		"chroma"
	)
	mm_chosen="${1}"
	TMP_FILE="${TMP_DIR}/background.jpg"

	case "${mm_chosen}" in
	blur)
		echo magick "${TMP_FILE}" -blur 0x4 "${HYPRLOCK_BG}"
		;;
	colour)
		echo magick "${TMP_FILE}" -fill indigo -colorize 40% -virtual-pixel edge "${HYPRLOCK_BG}"
		;;
	chroma | *)
		echo magick "${TMP_FILE}" -virtual-pixel edge -channel R -fx p[-10,-24] -channel B -fx p[24,10] -blur 0x18 "${HYPRLOCK_BG}"
		;;
	esac

}

random_hyprlock() {

	local RANDOM_PICTURE_PATH
	# local RANDOM_PICTURE
	local TMP_FILE
	local HYPRLOCK_BG
	local HYPR_DIR
	# local -i FREQ

	RANDOM_PICK="$(find "${WALLPAPER_DIR}" -type f | shuf --head-count=1)"
	HYPR_DIR="${HOME}/.config/hypr"
	HYPRLOCK_BG="${HYPR_DIR}/hyprlock-background"
	TMP_DIR="/tmp"
	MONITORS_QTY="$(hyprctl -j monitors | jq --raw-output '.[] .id' | wc --lines)"
	# FREQ=60
	# hyprctl hyprpaper listloaded to list loaded wallpaper
	if [[ "${1}" = hyprpaper ]]; then
		hyprctl hyprpaper preload "${RANDOM_PICK}"
		hyprctl hyprpaper wallpaper ",${RANDOM_PICK}"
	else
		swww img "${RANDOM_PICK}"
	fi
	#
	waypaper --backend hyprpaper --restore --random --fill fill --folder "${WALLPAPER_DIR}"

	RANDOM_PICTURE_PATH="$(waypaper --list | grep --invert-match "We got: en" | jq --raw-output '.[] .wallpaper')"
	# RANDOM_PICTURE="$(basename "${RANDOM_PICTURE_PATH}")"
	cp --verbose --force "${RANDOM_PICTURE_PATH}" "${TMP_DIR}/background.jpg"
	printf "Wallpaper %s set on %s\n" "${RANDOM_PICTURE_PATH}" "${MONITORS_QTY}"
	cp --verbose --force "${RANDOM_PICTURE_PATH}" "${HYPRLAND_PATH}/background.jpg"

	# for reference, won't be used by waypaper with sww, but was used by my configuration fo hyprpaper
	ln --force --symbolic --verbose "${RANDOM_PICTURE_PATH}" "$HYPR_DIR/wallpaper.jpg"

	if [[ -L "${HYPRLOCK_BG}" ]]; then
		rm --verbose "${HYPRLOCK_BG}"
	fi

	make_magick chroma

	unset WALLPAPER_DIR RANDOM_PICK RANDOM_PICTURE_PATH HYPR_DIR HYPRLOCK_BG TMP_DIR MONITORS_QTY FREQ RANDOM_PICTURE_PATH
}

main "${@}"
