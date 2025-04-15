#!/usr/bin/env bash

if command -v doas;then

#doas dnf -y copr enable pgdev/ghostty
#
#doas dnf -y copr enable peterwu/iosevka
#
#doas dnf -y copr enable solopasha/hyprland
#
#doas dnf -y copr enable tofik/nwg-shell
#
#doas dnf -y copr enable atim/starship
#
#doas dnf -y install hyprland
#
#doas dnf -y install hyprland-plugin-hyprbars
#
#doas dnf -y install stow hyprlock hypridle hyprpaper hyprlock hyprshot hyprdim hyprsunset cliphist waybar waypaper blueman network-manager-applet xwaylandvideobridge udiskie mpv feh zoxide jq qt6ct qt5ct qt6-qtwayland qt5-qtwayland copyq lsd ImageMagick GraphicsMagick swww wlogout wl-paste wl-clipboard wl-copy nwg-clipman nwg-shell-config nwg-drawer python-psutil fd brightnessctl btrbk micro restic bat cosmic-term starship swaync cargo satty vips uwsm
#
#doas dnf -y install rsms-inter{,-vf}-fonts jetbrains-mono-fonts-all iosevka-etoile-fonts
#
#doas dnf -y install golang gtk3-devel gtk4-devel gobject-introspection-devel gtk-layer-shell-devel

pushd "${HOME}/Downloads" || return
    git clone https://github.com/nwg-piotr/nwg-drawer
popd || return

pushd "${HOME}/Downloads/nwg-drawer" || return
    make get; make build; doas make install
popd || return


else
    echo "doas is not installed. will tray to install it"
    sudo dnf install opendoas
fi
