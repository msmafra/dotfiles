#!/usr/bin/env fish

set folders alacritty atuin azote bat Code .jq environment.d fish ghostty hypr kitty micro nwg-launchers nwg-drawer nwg-hud nwg-bar nwg-dock satty uwsm waypaper zed
set files starship.toml topgrade.toml mimeapps.list
set p_dotfiles $HOME/Projects/Mine/dotfiles
set p_configs $HOME/.config

for d in $folders
    mkdir -pv $p_dotfiles/$d/dot-config
    cp -ruv $p_configs/$d $p_dotfiles/$d/dot-config/
end
for f in $files
    cp -ruv $p_configs/$f $p_dotfiles/$f
end
