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
    rsync="--dry-run -haltzHAX --info=PROGRESS"
fi

folders=(
    ".jq"
)
folders_config=(
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
    "swaync"
    "systemd"
    "uwsm"
    "waybar"
    "waypaper"
    "zed"
)
files=(
    ".gtkrc-2.0"
    ".profile"
)
files_config=(
    "mimeapps.list"
    "starship.toml"
    "topgrade.toml"
)

printf "%s .config folders to syncronize...\n" "${#folders_config[@]}"
i=1
for d in "${folders_config[@]}"; do
    printf "Syncronizing folder #%s\n" "${i}"
    if [[ "${d}" =~ (^[.])([a-z0-9.-]+) ]]; then
        newname=${BASH_REMATCH[2]}
        echo "newname dot-$newname"
        ${dryrun:-} mkdir -pv "${p_dotfiles}/dot-${newname}/dot-config/${d}"
        echo ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${p_configs}/${d}/" "${p_dotfiles}/${newname}/dot-config/${d}/"
        ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${p_configs}/${d}/" "${p_dotfiles}/${newname}/dot-config/${d}/"
    else
        echo "no new name"
        ${dryrun:-} mkdir -pv "${p_dotfiles}/${d}/dot-config/${d}"
        echo ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${p_configs}/${d}/" "${p_dotfiles}/${d}/dot-config/${d}/"
        ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${p_configs}/${d}/" "${p_dotfiles}/${d}/dot-config/${d}/"
    fi
    ((i += 1))
    [[ $i -eq "${#folders[@]}" ]] && printf "#%s was the last one. Folders syncronization done." "$i"
done

unset BASH_REMATCH i d

printf "%s folders to syncronize...\n" "${#folders[@]}"
i=1
for d in "${folders[@]}"; do
    printf "Syncronizing folder #%s\n" "${i}"
    if [[ "${d}" =~ (^[.])([a-z0-9.-]+) ]]; then
        newname=${BASH_REMATCH[2]}
        echo "newname dot-$newname"
        ${dryrun:-} mkdir -pv "${p_dotfiles}/dot-${newname}/dot-config/${d}"
        echo ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${HOME}/${d}/" "${p_dotfiles}/${newname}/dot-config/${d}/"
        ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${HOME}/${d}/" "${p_dotfiles}/${newname}/dot-config/${d}/"
    else
        echo "no new name"
        ${dryrun:-} mkdir -pv "${p_dotfiles}/${d}/dot-config/${d}"
        echo ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${HOME}/${d}/" "${p_dotfiles}/${d}/dot-config/${d}/"
        ${dryrun:-} rsync --info COPY,DEL "${rsync}" "${HOME}/${d}/" "${p_dotfiles}/${d}/dot-config/${d}/"
    fi
    ((i += 1))
    [[ $i -eq "${#folders[@]}" ]] && printf "#%s was the last one. Folders syncronization done." "$i"
done

unset BASH_REMATCH i d

printf "%s files to syncronize...\n" "${#files_config[@]}"
for f in "${files_config[@]}"; do
    printf "Syncronizing file #%s\n" "${i}"
    if [[ "${f}" =~ (^[.])([a-z0-9.-]+) ]]; then
        newname=${BASH_REMATCH[2]}
        echo "newname dot-$newname"
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"dot-${newname}"
        echo ${dryrun:-} cp -v "${p_configs}/${f}" "${p_dotfiles}/dot-${newname}/"
        ${dryrun:-} cp -v "${p_configs}/${f}" "${p_dotfiles}/dot-${newname}/"
    else
        echo "no new name"
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"${f}"
        echo ${dryrun:-} cp -v "${p_configs}/${f}" "${p_dotfiles}/${f}/"
        ${dryrun:-} cp -v "${p_configs}/${f}" "${p_dotfiles}/${f}/"
    fi
    ((i += 1))
    [[ $i -eq "${#files[@]}" ]] && printf "#%s was the last one. Files syncronization done.\n" "$i"
done

unset BASH_REMATCH i f

printf "%s files to syncronize...\n" "${#files[@]}"
for f in "${files[@]}"; do
    printf "Syncronizing file #%s\n" "${i}"
    if [[ "${f}" =~ (^[.])([a-z0-9.-]+) ]]; then
        newname=${BASH_REMATCH[2]}
        echo "newname dot-$newname"
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"dot-${newname}"
        echo ${dryrun:-} cp -v "${HOME}/${f}" "${p_dotfiles}/dot-${newname}/"
        ${dryrun:-} cp -v "${HOME}/${f}" "${p_dotfiles}/dot-${newname}/"
    else
        echo "no new name"
        ${dryrun:-} mkdir -pv "${p_dotfiles}"/"${f}"
        echo ${dryrun:-} cp -v "${HOME}/${f}" "${p_dotfiles}/dot-${newname}/"
        ${dryrun:-} cp -v "${HOME}/${f}" "${p_dotfiles}/${f}/"
    fi
    ((i += 1))
    [[ $i -eq "${#files[@]}" ]] && printf "#%s was the last one. Files syncronization done.\n" "$i"
done

unset BASH_REMATCH i f

printf "All %s folders and all %s files syncronized. Everything done.\n" "${#folders[@]}" "${#files[@]}"
exit 0
