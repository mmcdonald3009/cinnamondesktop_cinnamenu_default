#!/bin/bash


if [ "$EUID" -gt 999 ]
then

if [ ! -f ~/.config/firstlogincomplete_DONOTDelete ];then

gsettings reset org.cinnamon panels-enabled
gsettings reset-recursively org.cinnamon

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

cinnamon --replace &

##If The Line Above ( cinnamon --replace & ) doesn't give the desired result, comment it out and uncomment the line below for a one-off forced logout at first time logging in only.
##This may be necessary when muffin wayland is releasedand I haven't tested that.
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

############ SET MAX NUMBER OF WORKSPACES IN 2 PLACES HERE ###############
if [ "$wksp" -gt 4 ];then
dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces "4"
xte 'key Escape'
fi
done

fi
}

function_preventnemohiddenfiles_limitworkspaces




