#!/bin/bash

chmod 700 ~/


if [ "$EUID" -gt 999 ]
then

function function_resetcinnamenu {
rm -rf ~/.config/cinnamon/spices/Cinnamenu@json/
mkdir ~/.config/cinnamon/spices/Cinnamenu@json/
cp /usr/share/cinnamon/applets/Cinnamenu@json/5.8/settings-schema.json ~/.config/cinnamon/spices/Cinnamenu@json/9999.json
dconf write /org/cinnamon/enabled-applets "'[]'" 
dconf write /org/cinnamon/enabled-applets " [ 'panel1:center:0:Cinnamenu@json', 'panel1:left:0:workspace-switcher@cinnamon.org' , 'panel1:left:1:grouped-window-list@cinnamon.org', 'panel1:right:0:systray@cinnamon.org', 'panel1:right:1:xapp-status@cinnamon.org', 'panel1:right:2:notifications@cinnamon.org', 'panel1:right:3:printers@cinnamon.org', 'panel1:right:4:removable-drives@cinnamon.org', 'panel1:right:5:keyboard@cinnamon.org', 'panel1:right:6:favorites@cinnamon.org', 'panel1:right:7:network@cinnamon.org', 'panel1:right:8:sound@cinnamon.org', 'panel1:right:9:power@cinnamon.org', 'panel1:right:10:calendar@cinnamon.org' ] "
gsettings reset org.cinnamon panels-enabled
gsettings reset-recursively org.cinnamon
dconf write /org/cinnamon/theme/name "'Light'"
dconf write /org/cinnamon/desktop/interface/gtk-theme "'Light'"
dconf write /org/cinnamon/desktop/interface/font-name "'Ubuntu Bold 11'"
}

result=$(jsonlint-php ~/.config/cinnamon/spices/Cinnamenu@json/9999.json)
if [[ ! $result == *"Valid JSON"* ]]; then
function_resetcinnamenu
fi

if [ ! -f ~/.config/cinnamon/spices/Cinnamenu@json/9999.json ];then
function_resetcinnamenu
fi

if [ ! -f ~/.config/firstlogincomplete_DONOTDelete ];then
rm ~/.local/share/applications/*.desktop
rm ~/Desktop/language-support.desktop
function_resetcinnamenu
gsettings reset org.cinnamon panels-enabled
gsettings reset-recursively org.cinnamon

dconf write /org/cinnamon/desktop/interface/icon-theme "'Sharp'"
dconf write /org/cinnamon/desktop/background/picture-uri "'file:///usr/share/wallpapers/material_wallpaper.jpg'"
dconf write /org/cinnamon/panels-resizable "['1:true']"
dconf write /org/cinnamon/panels-height "['1:40']"

dconf write /org/nemo/compact-view/default-zoom-level "'large'"

dconf write /org/nemo/icon-view/captions " ['none', 'none', 'none'] "
dconf write /org/nemo/icon-view/default-zoom-level "'large'"

dconf write /org/nemo/list-view/default-zoom-level "'standard'"
dconf write /org/nemo/list-view/default-visible-columns " ['name', 'size', 'type', 'date_modified', 'owner', 'permissions'] "
dconf write /org/nemo/list-view/default-column-order " ['name', 'size', 'type', 'date_modified', 'date_created_with_time', 'date_accessed', 'date_created', 'detailed_type', 'group', 'where', 'mime_type', 'date_modified_with_time', 'octal_permissions', 'owner', 'permissions', 'selinux_context'] "

dconf write /org/nemo/preferences/click-policy "'single'"
dconf write /org/nemo/preferences/always-use-browser "true"
dconf write /org/nemo/preferences/confirm-move-to-trash "true"
dconf write /org/nemo/preferences/show-image-thumbnails "'always'"
dconf write /org/nemo/preferences/show-location-entry "false"
dconf write /org/nemo/preferences/default-folder-viewer "'icon-view'"

dconf write /org/cinnamon/theme/name "'Light'"
dconf write /org/cinnamon/desktop/interface/gtk-theme "'Light'"
> ~/.config/firstlogincomplete_DONOTDelete

gsettings set org.cinnamon.desktop.wm.preferences num-workspaces "2"

##THIS MUST STAY
cinnamon-session-quit --logout --force 

fi 

rm ~/.bash_history
 
dconf write /org/nemo/preferences/show-hidden-files "false"
fi




killall nemo
killall dbus-monitor

function function_preventnemohiddenfiles_limitworkspaces {
if [ "$EUID" -gt 999 ];then
stdbuf -oL dbus-monitor --session interface='ca.desrt.dconf.Writer',member='Notify' |
while grep -q 'string "/org/nemo/preferences/show-hidden-files"'; do
nemo --quit
sleep 1
nemo --quit
dconf write /org/nemo/preferences/show-hidden-files false
gtk-launch nemo.desktop
killall dbus-monitor
function_preventnemohiddenfiles_limitworkspaces 
done &

stdbuf -oL dbus-monitor --session interface='ca.desrt.dconf.Writer',member='Notify' |
while grep -q 'string "/org/cinnamon/desktop/wm/preferences/num-workspaces"'; do
wksp=$(dconf read /org/cinnamon/desktop/wm/preferences/num-workspaces)
############ SET MAX NUMBER OF WORKSPACES HERE ###############
if [ "$wksp" -gt 4 ];then
dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces "4"
xte 'key Escape'
fi
done

fi
}

function_preventnemohiddenfiles_limitworkspaces




