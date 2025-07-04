#!/usr/bin/env bash
# Script for installing the newer stable version of Satty
# Installs to /opt/satty
# Puts the executable inside /usr/local/bin by symliking it
# Adapts the .desktop file to the paths changes and copies it to $HOME/.local/share/applicatons
# Copies the PNG icon to $HOME/.local/share/icons
sattyrizing() {

    local SCRIPT_NAME
    local URL
    local NEW_FILE
    local FILE
    local GET_VERSION
    local NEW_VERSION
    local DEST_DIR
    local ARTFACT_DIR

    SCRIPT_NAME="$(basename "${0}")"
    FILE="/tmp/satty.tar.gz"
    DEST_DIR="/opt"
    ARTFACT_DIR="${DEST_DIR}/satty"
    URL="https://api.github.com/repos/gabm/Satty/releases/latest"
    NEW_FILE="$(curl -s "${URL}" | grep "browser_download_url" | cut -d\" -f4 | grep ".tar.gz")"

    if [[ $(doas dnf list --installed | grep -Eo "satty") == "satty" ]];then
        printf "No need for %s script. Satty is installed via DNF" "${SCRIPT_NAME}"
        exit
    fi
    
    if [[ -f "${ARTFACT_DIR}/satty" ]]; then
        GET_VERSION="$(${ARTFACT_DIR}/satty --version | cut -d" " -f2)"
    else
        GET_VERSION="0"
    fi
    NEW_VERSION="$(printf "%s" "${NEW_FILE}" | cut -d"/" -f8 | sed 's/[a-z]//')"

    printf "Installed version: %s\n" "${GET_VERSION:-0}"
    printf "Remote version: %s\n" "${NEW_VERSION:-}"

    if [[ $(("10#${GET_VERSION//[a-zA-Z-.]/}")) -lt $(("10#${NEW_VERSION//[a-zA-Z-.]/}")) ]]; then

        curl -L# -C - "${URL}" --output "${FILE}"

        doas mkdir -pv "${ARTFACT_DIR}"

        doas tar --extract --verbose --file="${FILE}" --directory="${ARTFACT_DIR}"

        cp -fv "${ARTFACT_DIR}/satty.desktop" "$HOME/.local/share/applications/"
        cp -fv "${ARTFACT_DIR}/assets/satty.svg" "$HOME/.local/share/icons/"
        cp -fv "${ARTFACT_DIR}/completions/satty.fish" "$HOME/.local/share/fish/generated_completions/"
        doas ln -fs "${ARTFACT_DIR}/satty" "/usr/local/bin/satty"
        sed -i "s#Icon=satty#Icon=$HOME/.local/share/icons/satty.svg#g" "$HOME/.local/share/applications/satty.desktop"
    else
        printf "Satty is already in the latest stable version (%s)\n" "${GET_VERSION}"
    fi
    echo "Done!"

}
sattyrizing
