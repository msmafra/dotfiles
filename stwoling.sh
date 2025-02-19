#!/usr/bin/env bash

declare p_dotfiles
declare p_configs
declare -a folders
declare -a files
declare dryrun

if [[ "${1}" = "run" ]]; then
    dryrun=""
    rsync="-haltzHAX"
else
    dryrun="echo"
    rsync="-haltzHAX --dry-run"
fi

folders=(
    ".jq"
    "alacritty"
    "atuin"
    "bat"
    "environment.d"
    "fish"
    "ghostty"
    "gtk-3.0"
    "gtk-4.0"
    "hypr"
    "kitty"
    "micro"
    "nwg-bar"
    "nwg-dock"
    "nwg-drawer"
    "nwg-hud"
    "nwg-launchers"
    "qt5ct"
    "qt6ct"
    "satty"
    "uwsm"
    "waypaper"
    "zed"
)
files=(
    ".gtkrc-2.0"
    ".profile"
    "mimeapps.list"
    "starship.toml"
    "topgrade.toml"
)
declare p_dotfiles="$HOME/Projects/Mine/dotfiles"
declare p_configs="$HOME/.config"

for d in "${folders[@]}"; do
    if [[ "${d}" =~ (^[.])([a-z]+) ]]; then
        newname=${BASH_REMATCH[2]}
        ${dryrun:-} "dot-${newname}"
        ${dryrun:-} mkdir -pv "${p_dotfiles}/dot-${newname}/dot-config"
        echo rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${d}" "${p_dotfiles}/${newname}/dot-config/"
        rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${d}" "${p_dotfiles}/${newname}/dot-config/"
    else
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"${d}"/dot-config
        echo rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${d}" "${p_dotfiles}/${d}/dot-config/"
        rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${d}" "${p_dotfiles}/${d}/dot-config/"
    fi
done

echo "${BASH_REMATCH[*]}"

for f in "${files[@]}"; do
    if [[ "${d}" =~ (^[.])([a-z]+) ]]; then
        newname=${BASH_REMATCH[2]}
        echo rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${f}" "${p_dotfiles}/dot-${newname}"
        ${dryrun:-} rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${f}" "${p_dotfiles}/dot-${newname}"
    else
        echo rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${f}" "${p_dotfiles}/${f}"
        ${dryrun:-} rsync --info PROGRESS2,STATS "${rsync}" --stats "${p_configs}/${f}" "${p_dotfiles}/${f}"
    fi
done
