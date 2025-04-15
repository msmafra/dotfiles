#!/usr/bin/env bash
# Script for installing the newer stable version of Discord
# Installs to /opt/Discord
# Puts the executable inside /usr/local/bin by symliking it as discord instead of Discord
# Adapts the .desktop file to the paths changes and copies it to $HOME/.local/share/applicatons
# Copies the PNG icon to $HOME/.local/share/icons/hicolor/256x256/apps
not_concord() {

    local URL
    local DEST
    local FILE
    local GET_VERSION
    local NEW_VERSION
    local DEST_DIR
    local ARTFACT_DIR

    URL="https://discord.com/api/download?platform=linux&format=tar.gz"
    DEST="/opt"
    FILE="/tmp/discord-current.tar.gz"
    GET_VERSION="$(jq -r '.version' "${DEST}/Discord/resources/build_info.json")"
    # taken from https://github.com/mrkirby153/archlinux-discord/blob/main/archlinux_discord/discord.py
    NEW_VERSION="$(curl -s "https://discord.com/api/updates/stable?platform=linux" | jq -r '.name')"
    DEST_DIR="/opt"
    ARTFACT_DIR="${DEST_DIR}/Discord"

    printf "Installed version: %s\n" "$GET_VERSION"
    printf "Remote version: %s\n" "$NEW_VERSION"
    #printf "2025-02-11 not sure how to get newest version from remote with this script\n"

    if [[ $(("10#${GET_VERSION//[a-zA-Z-.]/}")) -lt $(("10#${NEW_VERSION//[a-zA-Z-.]/}")) ]]; then

        curl -L# -C - "${URL}" --output "/tmp/discord-current.tar.gz"

        doas tar --extract --verbose --file="${FILE}" --directory=/opt/

        cp -fv "${ARTFACT_DIR}/discord.desktop" "$HOME/.local/share/applications/"
        cp -fv "${ARTFACT_DIR}/discord.png" "$HOME/.local/share/icons/hicolor/256x256/apps/"

        doas ln -fs "${ARTFACT_DIR}/Discord" "/usr/local/bin/discord"

        sed -i "s#Exec=/usr/share/discord/Discord#Exec=discord#g" "$HOME/.local/share/applications/discord.desktop"
        sed -i "s#Path=/usr/bin#Path=/usr/local/bin#g" "$HOME/.local/share/applications/discord.desktop"
        sed -i "s#Icon=discord#Icon=$HOME/.local/share/icons/hicolor/256x256/apps/discord.png#g" "$HOME/.local/share/applications/discord.desktop"
    else
        printf "Discord is already in the latest stable version (%s)\n" "${GET_VERSION}"
    fi
    echo "Done!"

}
not_concord
