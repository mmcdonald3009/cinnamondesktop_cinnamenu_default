At time of writing I am using Debian 12 which is the current stable release. I am using SpiralLinux which formats as BTRFS and has snapper rollback in GRUB - many thanks to the OpenSUSE gecko dev for coming up with SpiralLinux.

First - why am I doing this - because as a very experienced senior systems admin who has been fiddling with Linux for years when I saw Cinnamon Desktop with Cinnamenu I knew we finally had a solid windows breaker.
Cinnamon is the maturity KDE wishes it could have. They have retained very early gnome functions which turns out to be the smartest way forawrd IMHO.
It's also a finger up at the rather obnoxious Linux Mint admin who talked to me like I an an idiot for suggesting my way to disable hidden files for regular users.

What you get:

1. A self healing Cinnamon implementation using Cinnamenu as default that is stable enough for commercial deployment ( some panel functions like add and remove get taken out) but MOVE is stil there ).
2. When a user toggles hidden files in Nemo, Nemo simply closes and restarts. Not a perfect solution but should keep your office workers from accidentally deleting hidden files.
3. You can set a limit to the number of workspaces a user may create.
4. At anytime you can stop 2 and 3 by typing killall dbus-monitor into a terminal.

How It All Works:

1. Copy 11_cinnamon.gschema.override into /usr/share/glib-2.0/schemas. Then as su/sudo run this from a terminal: glib-compile-schemas /usr/share/glib-2.0/schemas/
2. Copy /etc/xdg/autostart/z_login.desktop into /etc/xdg/autostart/z_login.desktop. This calls a script that runs per user $EUID at login. Very useful and good time to personalise and mount user specifics like named home remote mounts/drives.
3. mkdir /usr/share/customscripts and copy the file z_login.sh into it. chmod +x that file.


If you are interested in taking out the Add Panel and Remove Panel function and leaving the Move Panel function from Cinnamon Desktop, then as su/sudo run these commands:

sed -i 's|menu.addMenuItem(menuItem);||g' /usr/share/cinnamon/js/ui/panel.js 2>/dev/null
sed -i 's|menu.addMenuItem(menu.addPanelItem);||g' /usr/share/cinnamon/js/ui/panel.js 2>/dev/null
sed -i 's|this.addMenuItem(applet_settings_item);||g' /usr/share/cinnamon/js/ui/panel.js 2>/dev/null
sed -i 's|Restart Cinnamon|Restart Display|g' /usr/share/cinnamon/js/ui/panel.js 2>/dev/null
sed -i 's|menu.addMenuItem(panelEditMode);||g' /usr/share/cinnamon/js/ui/panel.js 2>/dev/null
sed -i 's|Restarting Cinnamon|Restarting Display|g' /usr/share/cinnamon/js/ui/main.js 2>/dev/null
sed -i 's|this.addMenuItem(new SettingsLauncher(_("System Settings"), "", "preferences-desktop"));||g' /usr/share/cinnamon/js/ui/panel.js 2>/dev/null
sed -i 's|menu.addMenuItem(menu.troubleshootItem);||g' /usr/share/cinnamon/js/ui/panel.js 2>/dev/null 

END OF README---
