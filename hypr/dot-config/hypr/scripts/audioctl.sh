#!/usr/bin/env bash

check_get_myxer() {
    local -a git_urls
    local author_crumb
    local product_crumb
    local filter_string

    git_urls=(
        "https://github.com"
        "https://gitlab.com"
    )
    which_git="${git_urls[${1}]}"
    author_crumb="${2}"
    product_crumb="${3}.git"
    # if [[ -n "${4}" ]]; then
    #     filter_string="| grep ${4}"
    # fi
    #
    filter_string="grep GE-Proton"

    git ls-remote --refs --sort="version:refname" --tags "${which_git}/${author_crumb}/${product_crumb}" | cut --delimiter="/" --fields=3 "${filter_string:-}" | tail --lines=1

}
check_get_myxer "${@}"
