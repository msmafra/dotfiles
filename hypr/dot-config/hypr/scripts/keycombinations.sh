#!/usr/bin/env bash
# from https://stackoverflow.com/questions/49037956/how-to-merge-arrays-from-two-files-into-one-array-with-jq/
give_me_keybinds() {

    local s_path
    s_path="${HOME}/.config/hypr/scripts"

    # hyprctl binds -j | \
    # jq --raw-output '["Description", "Mod mask", "Key"], (.[] | select(.has_description==true) | [.description, .modmask, .key]) | @csv ' | \
    # csview --style rounded
    # jq -L"${s_path}" --slurp 'include "joins"; joins(.modmask)' "${s_path}/modkeys.json" "${s_path}/binds.json"
    jq -L"${s_path}" --slurp 'include "joins"; joins(.modmask)' "${s_path}/modkeys.json" "${s_path}/binds.json"
    #jq -r '(.modname) + " " + (.key) + " " + (.description)'
}
give_me_keybinds
