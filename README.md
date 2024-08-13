------------------------------------
What You Get And What It Does
------------------------------------
<br>

1. A "self healing" Cinnamon Desktop implementation using Cinnamenu as the default Menu applet that is made stable enough for commercial deployment ( some panel functions like add and remove can be removed - procedures are below at bottom of page - BE CAREFUL ).<br>
2. When a user toggles hidden files in Nemo, Nemo simply closes and restarts.<br>Not a perfect solution but should keep your office workers from accidentally deleting hidden files.<br>
3. You can set a limit to the number of workspaces a user may create.<br>
4. At anytime you can stop pt's (2 & 3 above) by typing into a terminal: killall dbus-monitor.
<br>Logout and then Login and they will be running again. 
<br>
At time of writing I am using Debian 12 which is the current stable release.<br>
I am using SpiralLinux which formats as BTRFS and has snapper rollback in the GRUB menu!<br>
Many Many Many thanks to the OpenSUSE GeckoLinux dev for coming up with SpiralLinux.<br>
https://spirallinux.github.io/#download
<br><br>


First - why am I doing this - because as a tinkerer who has been fiddling with Linux for 18 years when I saw Cinnamon Desktop with Cinnamenu I knew we finally had a solid windoze killer.<br><br>
Cinnamon IS the maturity KDE wishes it could have. They have retained very early lightweight gnome javascript functions which turns out to be the smartest way forward IMHO.<br><br>
It's also a snout at the rather obnoxious Linux Mint forum admin who rubbished me and stated my way to disable hidden files availability for regular users was the most useless post he'd ever seen. If you've ever been a sysadmin you'll know that something is better than nothing...mate!
<br>
<br>
<br>

------------------------------------------
The Extra's To Download / Install
------------------------------------------
<br>

1. Download Cinnamenu - was here at time of writing: https://cinnamon-spices.linuxmint.com/applets/view/322<br>
2. Copy the Cinnamenu@json files into /usr/share/cinnamon/applets/Cinnamenu@json/<br>
3. INSTALL PACKAGES:# apt install xautomation jsonlint libgtk-3-bin<br>
* xautomation allows for bash script key emulation when using Expo applet to manage number of workspaces ( ctrl + alt + up ).
  If attempt is made to exceed MAX NUMBER OF WORKSPACES ( you set MAX in z_login.sh, see up above ), a dconf write to number of workspaces is made to hold MAX, and ESC key press is emulated to close the Expo page.<br>
* jsonlint checks the integrity of json files.<br>
* libgtk-3-bin provides gtk-launch for launching .desktop files from a terminal.<br> 
<br>


----------------------------------------------
All That Needs To Be Done To Make It Work...
----------------------------------------------
<br>

1. Copy 11_cinnamon.gschema.override into /usr/share/glib-2.0/schemas. Then as su/sudo run this in a terminal: glib-compile-schemas /usr/share/glib-2.0/schemas/<br>
2. Copy /etc/xdg/autostart/z_login.desktop into /etc/xdg/autostart/. This calls a script (z_login.sh) that runs per user $EUID at login.<br>
3. Make a directory: /usr/share/customscripts and copy the files z_login.sh and 9999.json into it.<br>
 (9999.json is just a modified to my requirements copy of /usr/share/cinnamon/applets/Cinnamenu@json/4.0/settings-schema.json). You might want change 4.0 to 5.8 on later Cinnamon versions or if using actual Mint.<br> You also might want your own default Cinnamenu configuration ( custom layout, what appears, etc ) just change settings-schema.json to what you want and save as 9999.json .<br>
4. chmod +x /usr/share/customscripts/z_login.sh.<br>
<br>
<br>
<br>

--------------------------------------------------------
To Change The MAX Number Of Workspaces A User May Create
--------------------------------------------------------
Change the value in z_login.sh by changing both the numbers under this line (4 is default):<br>
############ SET MAX NUMBER OF WORKSPACES HERE ###############<br>
if [ "$wksp" -gt 4 ];then<br>
dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces "4".<br>
<br>
<br>
<br>
-------------------------------------------------------------------------------------------------------------------------
What To Do If You Have Different Applets To Those Specified In The Provided File<br>/usr/share/glib-2.0/schemas/11_cinnamon.gschema.override
-------------------------------------------------------------------------------------------------------------------------

<br>
Change them in the file, and ensure ( you can copy and paste the array directly from this file ) into the function_resetcinnamenu<br>
in /usr/share/customscripts/z_login.sh. As long as these files have the same array content everything will work.
Also, if you do modify /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override then you will have to run this from su/sudo again in a terminal:<br>
glib-compile-schemas /usr/share/glib-2.0/schemas/
<br>
<br>
Here Is The Current Array So You May Compare If All These Applets Are Currently In /usr/share/cinnamon And Modify If Required:
<br>
<br>
enabled-applets=[ 'panel1:center:0:Cinnamenu@json', 'panel1:left:0:workspace-switcher@cinnamon.org' , 'panel1:left:1:grouped-window-list@cinnamon.org', 'panel1:right:0:systray@cinnamon.org', 'panel1:right:1:xapp-status@cinnamon.org', 'panel1:right:2:notifications@cinnamon.org', 'panel1:right:3:printers@cinnamon.org', 'panel1:right:4:removable-drives@cinnamon.org', 'panel1:right:5:keyboard@cinnamon.org', 'panel1:right:6:favorites@cinnamon.org', 'panel1:right:7:network@cinnamon.org', 'panel1:right:8:sound@cinnamon.org', 'panel1:right:9:power@cinnamon.org', 'panel1:right:10:calendar@cinnamon.org' ]
<br>
<br>
<br>

---------------------------------------------------------------------------------------------------------------
What Happens At Next Login Of The Very First Ever Created User <br> ( the user account created during OS setup/install ) ?
---------------------------------------------------------------------------------------------------------------
<br>
1. /etc/xdg/autostart/z_login.desktop calls script /usr/share/customscripts/z_login.sh, which does the following:
<br>
2. The first user that was created during setup/install - when logging out and back in for the very first time - a check is made for a filename: ~/.config/firstlogincomplete_DONOTDelete.<br>
3. This filename ~/.config/firstlogincomplete_DONOTDelete won't be there yet, because of missing filename the Cinnamenu schema file 9999.json will be copied into ~/.config/cinnamon/spices/Cinnamenu@json, and a dconf write will enable the default applets - including Cinnamenu.<br>
4. Auto forced logging out will happen just this once by: cinnamon-session-quit --logout --force <br>
5. The file ~/.config/firstlogincomplete_DONOTDelete will be created so going forward that file is found and so during future logins it's triggers/functions/forced logout get skipped.<br>
6. Now your first ever user that was created during first setup/install when logging in again next time and going forward gets Cinnamenu.
<br>
<br>
<br>

-----------------------------------------------------
What Happens At Login Of Subsequently Created Users?
-----------------------------------------------------
<br>
Subsequently created users will get Cinnamenu as default.<br>
They will also be automatically logged out once, only, and never again because the file ~/.config/firstlogincomplete_DONOTDelete will be created.
<br>
<br>
<br>

----------------------------------
What Happens At Every Other Login?
----------------------------------
<br>
At every login we run jsonlint to check the integrity of 9999.json.<br>If the file fails, it will be copied in from and overwritten by /usr/share/customscripts/9999.json<br>
Also, if for some strange reason the file is missing it ( 9999.json ) will also be copied in from and overwritten.
<br>
<br>
<br>
<br>

----------------------------------------------------
--- BEGIN OF BE "VERY VERY VERY" CAREFUL SECTION ---
----------------------------------------------------

<br>
<br>
PROCEDURES TO REMOVE "Add Panel" and "Remove Panel" and "Other Stuff"  FUNCTIONS FROM CINNAMON <br>
I would take a backup of /usr/share/cinnamon/js/panel.js, main.js, applet.js, everything, etc just in case you need to restore them.
<br>
<br>
DO THESE ONE BY ONE TO SEE THE CHANGES THINGS LIKE Add Applet To Panel, Remove From Panel, Applet Configure<br>
WILL ALSO WILL BE REMOVED AND THEN YOU CAN RESTORE FROM YOUR BACKED UP FILE COPIES IF REQUIRED.
<br>
<br>
EVEN WITH A BROKEN PANEL YOU CAN PROBABLY RIGHT-CLICK AND RUN TERMINAL, AND LAUNCH NEMO TO COPY/PASTE/RENAME BACKUPS ( ...edit as root ).
<br>
<br>
------------This sed does find and replace in files ------------<br>
sed -i 's|menu.addMenuItem(menuItem);||g' /usr/share/cinnamon/js/ui/panel.js <br>
sed -i 's|menu.addMenuItem(menu.addPanelItem);||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|this.addMenuItem(applet_settings_item);||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|menu.addMenuItem(panelEditMode);||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|this.addMenuItem(new SettingsLauncher(_("System Settings"), "", "preferences-desktop"));||g' /usr/share/cinnamon/js/ui/panel.js  <br>
sed -i 's|menu.addMenuItem(menu.troubleshootItem);||g' /usr/share/cinnamon/js/ui/panel.js <br>
sed -i "s|this._applet_context_menu.addMenuItem(this.context_menu_item_remove);||g" /usr/share/cinnamon/js/ui/applet.js <br>  
sed -i "s|(this.context_menu_item_configure) == -1|(this.context_menu_item_configure) == 100|g" /usr/share/cinnamon/js/ui/applet.js <br>  
sed -i "s|this.context_menu_item_remove.connect('activate', (actor, event) => this.confirmRemoveApplet(event));||g" /usr/share/cinnamon/js/ui/applet.js <br>
sed -i 's|self.sidePage.add_widget(page)||g' /usr/share/cinnamon/cinnamon-settings/modules/cs_panel.py <br>
<br>
<br>
------------This grep locates text in files to get a line number into variable so sed can remove that line number------------<br>
NOTE: This is a function between "if and fi" so those and all lines between must be pasted into the terminal together.<br>
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

------------------------------------------------------------------------------------------------------
Restrict Users To A Good Known Set Of Applets, Desklet and Extensions And Remove Ability to Modify Them.
The Defaults That Ship With The Cinnamon Desktop Are Probably Enough For Productive Computing.
------------------------------------------------------------------------------------------------------
<br>
rm /usr/share/applications/cinnamon-settings-applets.desktop <br>
rm /usr/share/applications/cinnamon-settings-desklets.desktop <br>
rm /usr/share/applications/cinnamon-settings-extensions.desktop <br>
rm /usr/share/applications/cinnamon-settings-workspaces.desktop <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_applets.py <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_desklets.py <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_extensions.py <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_workspaces.py <br>

<br>
<br>
<br>
--- END OF BE VERY CAREFUL SECTION ---<br><br>

You will note other non-relevant stuff in z_login.sh I have left there for educational purposes.<br><br>
Have a good day and try and be nice to others :)
<br><br>

---END OF README---
