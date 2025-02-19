#!/usr/bin/env bash
########################################################
#
# This is not ready. Just an idea to be worked on another time
# Work In Progress
#
#
#
########################################################
# ${base_path}/hyprpaper.conf:$mon2 = DP-1
# ${base_path}/waybar/output.json:	"output": ["DP-1", "eDP-1"],
# ${base_path}/waybar/workspaces.json:	"DP-1": [1, 2, 3, 4, 5],
# ${base_path}/waybar/style.css:/* window.eDP-1 * { font-size: 12px; } */
# ${base_path}/preferences.conf:$mon2 = DP-1

# ❯ printenv | grep -i GNOME
# DESKTOP_SESSION=gnome
# MEMORY_PRESSURE_WATCH=/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/session.slice/org.gnome.Shell@wayland.service/memory.pressure
# XDG_CURRENT_DESKTOP=GNOME
# XDG_SESSION_DESKTOP=gnome
# GDMSESSION=gnome
# GNOME_SETUP_DISPLAY=:1
# XDG_MENU_PREFIX=gnome-
# ❯ printenv | grep -i wayland
# QT_WAYLAND_DECORATION=adwaita
# XAUTHORITY=/run/user/1000/.mutter-Xwaylandauth.FJR1U2
# MEMORY_PRESSURE_WATCH=/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/session.slice/org.gnome.Shell@wayland.service/memory.pressure
# XDG_SESSION_TYPE=wayland
# WAYLAND_DISPLAY=wayland-0
#  ❯ printenv | grep -i display
# DISPLAY=:0
# GNOME_SETUP_DISPLAY=:1
# WAYLAND_DISPLAY=wayland-0

main() {

    local base_path
    local -a display_files

    base_path="$HOME/.config/hypr"
    display_files=(
        "hyprpaper.conf"
        "waybar/output.json"
        "waybar/workspaces.json"
        # "${base_path}/waybar/style.css"
        "preferences.conf"
    )
    for df in "${display_files[@]}"; do
        printf "%s/%s\n" "${base_path}" "$df"
        sed 's#DP-1#HDMI-A-1#g' "${base_path}/$df"
    done
}
json_replace() {

    JSON=$(
        cat <<-END
  {
    "what":"something",
    "when":"now"
  }
END
    )

    echo "$JSON"

}
main "${@}"
