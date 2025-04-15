get_latest_git_release() {

    local URL
    local NEW_FILE
    local FILE
    local GET_VERSION
    local NEW_VERSION
    local ARTFACT_DIR
    local PROJ_NAME
    usage="
    from git url provide the owner and the project name in the format:
    ${SCRIPT_NAME} OWNER/PROJECT
    "
    PROJ_NAME="${1}"
    regex="([a-zA-Z0-9-]{1,})(\/)([a-zA-Z0-9-]{1,})"
    if [[ -z "${*}" ]];then
        echo $usage
        exit 1
    fi
    if [[ "${1}" =~ ${regex} ]];then
        echo -e "regex template: $regex\nString passed: $PROJ_NAME\nProject ownner: ${BASH_REMATCH[1]}\nProject name: ${BASH_REMATCH[3]}\nFull bash regex match: ${BASH_REMATCH[*]}"
    else
        echo -e "no regex match "${BASH_REMATCH[*]}""
    fi
    URL="https://api.github.com/repos/${BASH_REMATCH[1]}/${BASH_REMATCH[3]}/releases/latest"
    FILE="/tmp/${BASH_REMATCH[3]}.tar.gz"
    ARTFACT_DIR="/tmp/${BASH_REMATCH[3]}"
    # NEWEST_FILE="$(curl -s "${URL}" | grep "browser_download_url" | cut -d\" -f4 | grep ".tar.gz")"
    NEWEST_FILE="$(curl -s "${URL}" | grep "tarball_url" | cut -d\" -f4).tar.gz"

    echo -e "URL: $URL\nFile:$FILE\nArtfact: $ARTFACT_DIR\nNewest file: ${NEWEST_FILE}"



    exit 0

    if [[ -f "${ARTFACT_DIR}/satty" ]]; then
        GET_VERSION="$(${ARTFACT_DIR}/satty --version | cut -d" " -f2)"
    else
        GET_VERSION="0"
    fi
    NEW_VERSION="$(printf "%s" "${NEW_FILE}" | cut -d"/" -f8 | sed 's/[a-z]//')"

    printf "Installed version: %s\n" "${GET_VERSION:-0}"
    printf "Remote version: %s\n" "${NEW_VERSION:-}"

    # if [[ $(("10#${GET_VERSION//[a-zA-Z-.]/}")) -lt $(("10#${NEW_VERSION//[a-zA-Z-.]/}")) ]]; then

    #     curl -L# -C - "${URL}" --output "${FILE}"

    #     doas mkdir -pv "${ARTFACT_DIR}"

    #     doas tar --extract --verbose --file="${FILE}" --directory="${ARTFACT_DIR}"
}
get_latest_git_release "${@}"
