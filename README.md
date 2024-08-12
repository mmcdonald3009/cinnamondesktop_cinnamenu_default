
What You Get:
<br>
<br>
1. A "self healing" Cinnamon Desktop implementation using Cinnamenu as the default Menu applet that is stable enough for commercial deployment ( some panel functions like add and remove can get taken out - procedures are below at bottom of page - BE CAREFUL ).<br>
2. When a user toggles hidden files in Nemo, Nemo simply closes and restarts. Not a perfect solution but should keep your office workers from accidentally deleting hidden files.<br>
3. You can set a limit to the number of workspaces a user may create ( change this value in z_login.sh by changing the number in: dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces "4" )<br>
4. At anytime you can stop pt's (2 & 3 above) by typing into a terminal: killall dbus-monitor. Logout and then Login and they are running again. 
<br>
<br>
<br>
At time of writing I am using Debian 12 which is the current stable release. I am using SpiralLinux which formats as BTRFS and has snapper rollback in GRUB - many many many thanks to the OpenSUSE geckolinux dev for coming up with SpiralLinux.<br>
https://spirallinux.github.io/#download
<br><br>


First - why am I doing this - because as a tinkerer who has been fiddling with Linux for 18 years when I saw Cinnamon Desktop with Cinnamenu I knew we finally had a solid windoze killer.<br><br>
Cinnamon IS the maturity KDE wishes it could have. They have retained very early lightweight gnome javascript functions which turns out to be the smartest way forward IMHO.<br><br>
It's also a snout at the rather obnoxious Linux Mint forum admin who rubbished me and stated my way to disable hidden files availability for regular users was useless.<br>
Mate you may not have known me but you might now... ( laughing )...
<br>
<br>
<br>
The Extra's You Have to Get First...
<br>
<br>
1. Download Cinnamenu was here at time of writing: https://cinnamon-spices.linuxmint.com/applets/view/322<br>
2. Copy the Cinnamenu@json files into /usr/share/cinnamon/applets/Cinnamenu@json/
3. xautomation allows for ESC key emulation when if using EXPO applet to create workspaces ( ctrl + alt + up ) when the count goes above 4, a dconf write to number of workspaces 4 is made, and ESC key triggered to close page.<br>
4. jsonlint checks the integrity of json files.<br>
5. libgtk-3-bin provides gtk-launch for launching .desktop files from a terminal.<br>
6. So do this: apt install xautomation jsonlint libgtk-3-bin
<br>
<br>
<br>
To Make It Work...
<br>
<br>
1. Copy 11_cinnamon.gschema.override into /usr/share/glib-2.0/schemas. Then as su/sudo run this from a terminal: glib-compile-schemas /usr/share/glib-2.0/schemas/<br>
2. Copy /etc/xdg/autostart/z_login.desktop into /etc/xdg/autostart/. This calls a script (z_login.sh) that runs per user $EUID at login. Very useful and good time to personalise and mount user ID specifics like named home remote mounts/drives/smb shares.<br>
3. Make a directory: /usr/share/customscripts and copy the files z_login.sh and 9999.json into it.<br>
 (9999.json is just a modified to my requirements copy of /usr/share/cinnamon/applets/Cinnamenu@json/4.0/settings-schema.json). You might want change 4.0 to 5.8 on later Cinnamon versions or if using actual Mint.<br>
4. chmod +x /usr/share/customscripts/z_login.sh.<br>
<br>
<br>
<br>
What Happens At Login Of The Very First User? <br>
<br>
(/etc/xdg/autostart/z_login.desktop calls script /usr/share/customscripts/z_login.sh).
<br>It does the following:
<br>
The first user that was created during setup/install and then when logging out and back in for the very first time, a check is made for a file named: ~/.config/firstlogincomplete_DONOTDelete.<br>
This file ~/.config/firstlogincomplete_DONOTDelete won't be there yet, so the Cinnamenu schema file 9999.json wil be copied into ~/.config/cinnamon/spices/Cinnamenu@json, and a dconf write enables the default applets including Cinnamenu.<br>
Logging out happens only once due in this part of z_login.sh: cinnamon-session-quit --logout --force <br>
The file ~/.config/firstlogincomplete_DONOTDelete will be created so the logout check passes over it next time.<br>
Now your first ever user that was created during first setup/install when logging in again gets Cinnamenu and won't ever get logged out again unless ~/.config/firstlogincomplete_DONOTDelete is removed.
<br>
<br>
<br>
What Happens At Login Of Subsequently Created Users?
<br>
<br>
Subsequently created users will get Cinnamenu as default.
They will also be automatically logged out once, only, and never again after ~/.config/firstlogincomplete_DONOTDelete is created.
<br>
<br>
<br>
What Happens At Every Other Login?
<br>
<br>
At every login we run jsonlint to check the integrity of 9999.json. If the file fails, it will be copied in from and overwritten by /usr/share/customscripts/9999.json<br>
Also, if for some strange reason the file is missing it ( 9999.json ) will get copied in again.
<br>
<br>
--- BEGIN OF BE VERY VERY VERY CAREFUL ---
<br>
<br>
PROCEDURES TO REMOVE "Add Panel" and "Remove Panel" and "Other Stuff"  FUNCTIONS FROM CINNAMON <br>
I would take a backup of /usr/share/cinnamon/js/panel.js, main.js, applet.js, everything, etc just in case you need to restore them.<br>
DO THESE ONE BY ONE TO SEE THE CHANGES THINGS LIKE Add Applet To Panel, Remove From Panel, Applet Configure<br>
WILL ALSO WILL BE REMOVED AND THEN YOU CAN RESTORE FROM YOUR BACKED UP FILE COPIES IF REQUIRED
<br>
<br>
------------The sed stuff deals with find and replace------------<br>
sed -i 's|menu.addMenuItem(menuItem);||g' /usr/share/cinnamon/js/ui/panel.js <br>
sed -i 's|menu.addMenuItem(menu.addPanelItem);||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|this.addMenuItem(applet_settings_item);||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|menu.addMenuItem(panelEditMode);||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|this.addMenuItem(new SettingsLauncher(_("System Settings"), "", "preferences-desktop"));||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|menu.addMenuItem(menu.troubleshootItem);||g' /usr/share/cinnamon/js/ui/panel.js <br>
sed -i "s|this._applet_context_menu.addMenuItem(this.context_menu_item_remove);||g" /usr/share/cinnamon/js/ui/applet.js <br>  
sed -i "s|(this.context_menu_item_configure) == -1|(this.context_menu_item_configure) == 100|g" /usr/share/cinnamon/js/ui/applet.js <br>  
<br>
sed -i "s|this.context_menu_item_remove.connect('activate', (actor, event) => this.confirmRemoveApplet(event));||g" /usr/share/cinnamon/js/ui/applet.js <br>
sed -i 's|self.sidePage.add_widget(page)||g' /usr/share/cinnamon/cinnamon-settings/modules/cs_panel.py <br>
<br>
<br>
------------This grep stuff deals with locating text in files and finding the line number and putting into variable so sed can remove that line by number------------<br>
if grep -q "(items.indexOf(this.context_menu_item_remove) == -1)" /usr/share/cinnamon/js/ui/applet.js;then <br>
ln7=$(grep -n "(items.indexOf(this.context_menu_item_remove) == -1)" /usr/share/cinnamon/js/ui/applet.js | cut -d : -f 1) <br>
ln8=$((ln7 - 1)) <br>
ln9=$((ln8 + 1)) <br>
sed -i "${ln9}d" /usr/share/cinnamon/js/ui/applet.js <br>
sed -i "${ln8}d" /usr/share/cinnamon/js/ui/applet.js <br>
sed -i "${ln7}d" /usr/share/cinnamon/js/ui/applet.js<br>
fi <br>
<br>
sed -i "s|this._applet_context_menu.addMenuItem(this.context_menu_item_remove);||g" /usr/share/cinnamon/js/ui/applet.js <br>
sed -i "s|(this.context_menu_item_configure) == -1|(this.context_menu_item_configure) == 100|g" /usr/share/cinnamon/js/ui/applet.js <br>
<br>
<br>
<br>
THINK ABOUT LOCKING DOWN TO A GOOD KNOWN SET OF APPLETS, DESKLETS AND EXTENSIONS BY REMOVING USER ABILITY TO SET THEM.
THE DEFAULTS SHIPPED ARE PROBABLY ENOUGH FOR MOST PEOPLE TO ENGAGE IN MEANINGFUL WORKFLOW
rm /usr/share/applications/cinnamon-settings-applets.desktop 2>/dev/null
rm /usr/share/applications/cinnamon-settings-desklets.desktop 2>/dev/null
rm /usr/share/applications/cinnamon-settings-extensions.desktop 2>/dev/null
rm /usr/share/applications/cinnamon-settings-workspaces.desktop 2>/dev/null
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_applets.py 2>/dev/null
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_desklets.py 2>/dev/null
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_extensions.py 2>/dev/null
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_workspaces.py 2>/dev/null

<br>
<br>
<br>
--- END OF BE VERY CAREFUL ---<br><br>
You will note other non-relevant stuff in z_login.sh I have left there for educational purposes.<br><br>
<br><br>

END OF README---
