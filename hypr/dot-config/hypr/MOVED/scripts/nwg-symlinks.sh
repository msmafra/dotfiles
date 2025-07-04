#!/usr/bin/env bash

nwg_symlinks() {

	local base_path
	local orig_path
	local dest_path
	local nwg_cache
	local dest_cache

	base_path="$HOME/.config"
	orig_path="${base_path}/hypr/nwg"
	dest_path="${base_path}/nwg-drawer"
	nwg_cache="nwg-pin-cache"
	dest_cache="$HOME/.cache/${nwg_cache}"

	if [[ ! -f "${dest_cache}" ]]; then
		echo ln --force --symbolic "${orig_path}/${nwg_cache}" "${dest_cache}/${nwg_cache}"
	fi

	if [[ ! -f "${dest_path}" ]]; then
		echo mv --verbose "${base_path}/nwg-drawer{,.ORIGINAL}"
		echo ln --force --symbolic "${orig_path}/nwg-drawer" "${dest_path}"
	fi

}
nwg_symlinks "${@}"
