#!/usr/bin/env bash

# # Screenshot a window
# bind = $mainMod, PRINT, exec, hyprshot -m window
# # Screenshot a monitor
# bind = , PRINT, exec, hyprshot -m output
# # Screenshot a region
# bind = $shiftMod, PRINT, exec, hyprshot -m region

cosmic_capture() {
	local get_now
	local store_screenshots
	local screenshot

	get_now="$(date '+%y%m%d_%H%M%S')"
	store_screenshots="$HOME/Imagens/Screenshots"

    screenshot="$(cosmic-screenshot --modal=false --interactive=false --notify=true --save-dir="${store_screenshots}")"

	mv --verbose "${screenshot}" "${store_screenshots}"/Screenshot-"${get_now}".png

}
cosmic_capture
