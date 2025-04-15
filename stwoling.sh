#!/usr/bin/env bash
# https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

declare p_dotfiles
declare p_configs
declare -a folders
declare -a files
declare dryrun
p_dotfiles="$HOME/Projects/Mine/dotfiles"
p_configs="$HOME/.config"
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
    "dot-config/mimeapps.list"
    "dot-config/starship.toml"
    "dot-config/topgrade.toml"
)

printf "%s folders to syncronize...\n" "${#folders[@]}"
i=1
for d in "${folders[@]}"; do
    printf "Syncronizing folder #%s\n" "${i}"
    if [[ "${d}" =~ (^[.])([a-z]+) ]]; then
        newname=${BASH_REMATCH[2]}
        echo "newname dot-$newname"
        ${dryrun:-} mkdir -pv "${p_dotfiles}/dot-${newname}/dot-config"
        echo rsync --info PROGRESS2 "${rsync}" "${p_configs}/${d}" "${p_dotfiles}/${newname}/dot-config/"
        ${dryrun:-} rsync --info PROGRESS2 "${rsync}" "${p_configs}/${d}" "${p_dotfiles}/${newname}/dot-config/"
    else
        echo "no new name"
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"${d}"/dot-config
        echo rsync --info PROGRESS2 "${rsync}" "${p_configs}/${d}" "${p_dotfiles}/${d}/dot-config/"
        ${dryrun:-} rsync --info PROGRESS2 "${rsync}" "${p_configs}/${d}" "${p_dotfiles}/${d}/dot-config/"
    fi
    ((i += 1))
    [[ $i -eq "${#folders[@]}" ]] && printf "#%s was the last one. Folders syncronization done." "$i"
done

unset BASH_REMATCH i

printf "%s files to syncronize...\n" "${#files[@]}"
for f in "${files[@]}"; do
    printf "Syncronizing file #%s\n" "${i}"
    if [[ "${f}" =~ (^[.])([a-z]+) ]]; then
        newname=${BASH_REMATCH[2]}
        echo "newname dot-$newname"
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"dot-${newname}"
        echo rsync --info PROGRESS2 "${rsync}" "${p_configs}/${f}" "${p_dotfiles}/dot-${newname}/"
        ${dryrun:-} rsync --info PROGRESS2 "${rsync}" "${p_configs}/${f}" "${p_dotfiles}/dot-${newname}/"
    else
        echo "no new name"
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"${f}"
        echo rsync --info PROGRESS2 "${rsync}" "${p_configs}/${f}" "${p_dotfiles}/${f}/"
        ${dryrun:-} rsync --info PROGRESS2 "${rsync}" "${p_configs}/${f}" "${p_dotfiles}/${f}/"
    fi
    ((i += 1))
    [[ $i -eq "${#files[@]}" ]] && printf "#%s was the last one. Files syncronization done.\n" "$i"
done

unset BASH_REMATCH i

printf "All %s folders and all %s files syncronized. Everything done.\n" "${#folders[@]}" "${#files[@]}"
exit 0
