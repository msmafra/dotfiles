# Hyprland dotfiles and such (WIP) ... endlessly... probably 😜

## My dot files
This is all done over Fedora Workstation 40 (now 42). So Gnome is used to set everything and is kept installed in case of "rare" (😅) breaking change on Hyprland side.

https://github.com/user-attachments/assets/b8375f97-4df1-4d8d-85f7-69ab288239b7

## To "magically" restore the configuration files, GNU stow is needed.
If it is already installed, a simulation/dry-run can be useful since if some filse of folders already exist they won't be replace/updated.
```
cd ~/Dowloads
git clone https://github.com/zumnebel/dotfiles
cd dotfiles
stow -n -v 2 --dotfiles -t ~/
```

### What is used here that need to be installed on Fedora Workstation 40 and up
- Atuin
- Starship
- stow
- doas (or sudo);
- [uwsm](https://github.com/Vladimir-csp/uwsm);
- Hyprland;
- Hyprbars;
- Hyprdim;
- Hyprlock;
- Hypridle;
- Hyprshot;
- Hyprpaper;
- Hyprpicker;
- Hyprsunset;
- Hyprsyteminfo;
- [Satty](https://api.github.com/repos/gabm/Satty);
- [Waybar](https://github.com/Alexays/Waybar);
- [Wlogout](https://github.com/ArtsyMacaw/wlogout);
- [nm-applet (network-manager-applet)](https://gitlab.gnome.org/GNOME/network-manager-applet);
- [pavucontrol](https://flathub.org/apps/org.pulseaudio.pavucontrol);
- [Myxer](https://github.com/Aurailus/Myxer);
- [nwg-drawer](https://github.com/nwg-piotr/nwg-drawer). Manually compiled v0.6.0 or up since it's not available via COPR [2025-02-13];
- [nwg-displays (must have a separate workspaces.conf file)](https://github.com/nwg-piotr/nwg-displays);
- [nwg-clipman](https://github.com/nwg-piotr/nwg-clipman);
- [swaync (SwayNotificationCenter)](https://github.com/ErikReider/SwayNotificationCenter);
- [cliphist](https://github.com/sentriz/cliphist);
- Kitty / Alacritty / Ghostty / COSMIC Term / Ptyxis;
- Nautilus;
- [COSMIC Files and COSMIC Settings](https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/);
- [Inter font 4.1](https://rsms.me/inter);
- [Iosevka](https://github.com/be5invis/Iosevka);
- [0xProto font](https://github.com/0xType/0xProto)
- [Geist Mono/Geist font](https://vercel.com/font)
- [Nerd Fonts](https://www.nerdfonts.com/cheat-sheet);
- [Waypaper](https://github.com/anufrievroman/waypaper);


### Some helpful links
1) https://cubic-bezier.com/
1) https://easings.net
1) https://https://www.cssportal.com/css-cubic-bezier-generator/
1) https://wiki.hyprland.org/0.47.0/Configuring/Animations/#animation-tree
1) https://colorhunt.co/palette/

### Enabling the COPRs
Unfortunately, not all packages are available, or updates are reasonably quick enough in the Fedora Repos, so some COPRs are needed.

```
doas dnf copr enable pgdev/ghostty -y

doas dnf copr enable peterwu/iosevka -y

doas dnf copr enable solopasha/hyprland -y

doas dnf copr enable tofik/nwg-shell -y

doas dnf copr enable atim/starship -y
```

For some wild reason, DNF doesn't accept (or wasn't at the time) to install the hyprland and hyprland-plugins packages, or individual hyprland plugins, on the same installation command line.
```
doas dnf install hyprland -y

doas dnf install hyprland-plugin-hyprbars -y
```

### Installing the rest

To use PPM with Satty  gdk-pixbuf2-modules-extra is needed. It can be installed directly your with the vips package

```
doas dnf -y install stow hyprlock hypridle hyprpaper hyprlock hyprshot hyprdim hyprsunset cliphist waybar waypaper blueman network-manager-applet xwaylandvideobridge udiskie mpv feh zoxide jq qt6ct qt5ct qt6-qtwayland qt5-qtwayland copyq lsd ImageMagick GraphicsMagick swww wlogout wl-paste wl-clipboard wl-copy nwg-clipman nwg-shell-config nwg-drawer python-psutil fd brightnessctl btrbk micro restic bat cosmic-term starship swaync cargo satty vips uwsm breeze-gtk plasma-breeze
```

### Installing Atuin.

```
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
sed '3i \    atuin init fish | source' ~/.config/fish/config.fish
printf 'eval "$(atuin init bash)"' | tee -a ~/.bashrc
```

Installing fonts. Inter, Iosevka and JetbrainMono can be installed from Fedora repos, or manually for a more recent version.

```
doas dnf -y copr enable peterwu/iosevka
doas dnf -y install rsms-inter{,-vf}-fonts jetbrains-mono-fonts-all iosevka-etoile-fonts
```
Or manuall for a more updated version if needed.
```
i_version="4.1"
cd ~/Dowloads/

curl -sL# https://github.com/rsms/inter/releases/download/v${i_version}/Inter-${i_version}.zip --output Inter-${i_version}.zip
curl -sL# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/NerdFontsSymbolsOnly.zip --output NerdFontsSymbolsOnly.zip

unzip -d Inter Inter-${i_version}.zip
unzip -d NerdFontsSymbols NerdFontsSymbolsOnly.zip

doas mkdir -v /usr/share/fonts/Inter
doas mkdir -v /usr/share/fonts/NerdFontsSymbols

doas cp -v Inter/Inter*.tt* /usr/share/fonts/Inter/
doas cp -v NerdFontsSymbols/*.ttf /usr/share/fonts/NerdFontsSymbols/

doas fc-cache --verbose --force

```

nwg-drawer can be built manually since it is not always up-to-date in the COPR (at moment at least) in the COPR. So:

### Clone the repos first
```
cd ~/Downloads
git clone https://github.com/nwg-piotr/nwg-drawer
```
#### Install uwsm depedencies and runtime depedencies to be sure and then build it
```
doas dnf install meson cmake scdoc dmenu python3-pyxdg python3-dbus -y
cd uwsm
meson setup --prefix=/usr/local -Duuctl=enabled -Dfumon=enabled -Duwsm-app=enabled build
meson install -C build
```

#### As nwg-drawer takes much longer to compile, we do it last.

```
doas dnf install gtk3-devel gtk4-devel gobject-introspection-devel gtk-layer-shell-devel
cd ../nwg-drawer
make get; make build; doas make install
```
