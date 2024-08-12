At time of writing I am using Debian 12 which is the current stable release. I am using SpiralLinux which formats as BTRFS and has snapper rollback in GRUB - many thanks to the OpenSUSE gecko dev for coming up with SpiralLinux.

First - why am I doing this - because as a very experienced senior systems admin who has been fiddling with Linux for years when I saw Cinnamon Desktop with Cinnamenu I knew we finally had a solid windows breaker.
Cinnamon is the maturity KDE wishes it could have. They have retained very early gnome functions which turns out to be the smartest way forward IMHO.
It's also a finger up at the rather obnoxious Linux Mint admin who talked to me like I an an idiot for suggesting my way to disable hidden files for regular users.

What You Get:

1. A self healing Cinnamon implementation using Cinnamenu as default that is stable enough for commercial deployment ( some panel functions like add and remove can get taken out) but MOVE is stil there.
2. When a user toggles hidden files in Nemo, Nemo simply closes and restarts. Not a perfect solution but should keep your office workers from accidentally deleting hidden files.
3. You can set a limit to the number of workspaces a user may create.
4. At anytime you can stop 2 and 3 by typing killall dbus-monitor into a terminal.

The Extra's You Have to Install First...

xautomation allows for ESC key emulation when if using EXPO applet to create workspaces ( ctrl + up ) when the count goes above 4, a dconf write to number of workspaces 4 is made, and ESC key triggered to close page.
jsonlint checks the integrity of xml files.
libgtk-3-bin provides gtk-launch for launching .desktop files ( found in /usr/share/applications) form terminal.
So do this: apt install xautomation jsonlint libgtk-3-bin


How It All Works:

1. Copy 11_cinnamon.gschema.override into /usr/share/glib-2.0/schemas. Then as su/sudo run this from a terminal: glib-compile-schemas /usr/share/glib-2.0/schemas/
2. Copy /etc/xdg/autostart/z_login.desktop into /etc/xdg/autostart/z_login.desktop. This calls a script that runs per user $EUID at login. Very useful and good time to personalise and mount user specifics like named home remote mounts/drives.
3. mkdir /usr/share/customscripts and copy the file z_login.sh into it. chmod +x that file.

What Happens At Login? (/etc/xdg/autostart/z_login.desktop calls script /usr/share/customscripts/z_login.sh). It does the following:
1. The first user created when logging out and back in for the very first time, a check is made for a file named: ~/.config/firstlogincomplete_DONOTDelete.
~/.config/firstlogincomplete_DONOTDelete won't be there so the Cinnamenu schema file 9999.json wil be copied into ~/.config/cinnamon/spices/Cinnamenu@json, and a dconf write enables the default applets including Cinnamenu.
There's other stuff in z_login.sh that is not relevant but I've left there in case it is of educational value to someone.
Now that file will be created so the check passes over it next time.
You will be logged out in this part of z_login.sh: cinnamon-session-quit --logout --force
Now your first ever user when logging in again gets Cinnamenu.

You will also note a function_resetcinnamenu


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
