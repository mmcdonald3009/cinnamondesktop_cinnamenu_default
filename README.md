------------------------------------
About
------------------------------------
<br>

1. Cinnamenu as default Menu on a single moveable cinnamon desktop panel.<br>
 Some panel functions like Add Panel and Remove Panel MUST be deleted for stability - procedures are below.<br> Nothing is dangerous when everything is properly considered.<br>
2. When a user toggles hidden files in Nemo, Nemo simply closes and restarts.<br>Not a perfect solution but should keep kids from accidentally deleting hidden files.<br>
3. You can set a limit to the number of workspaces a user may create.<br>
4. At anytime you can stop (2 & 3 above ) by typing into a terminal:# killall dbus-monitor.
<br>Logout and then Login and they will be running again. 
<br>
At time of writing I am using Debian 12.6, this is the minimum so do apt upgrade if you are using an earlier version.<br>
I am using SpiralLinux which formats as BTRFS and has snapper rollback in the GRUB menu!<br>
Many Many Many thanks to the OpenSUSE GeckoLinux dev for coming up with SpiralLinux.<br>
https://spirallinux.github.io/#download
<br>
<br>
<br>

------------------------------------------
Download & Install
------------------------------------------
<br>

1. Download Cinnamenu - was here at time of writing: https://cinnamon-spices.linuxmint.com/applets/view/322<br>
2. Copy the Cinnamenu@json files into /usr/share/cinnamon/applets/Cinnamenu@json/<br>
3. INSTALL PACKAGE:# apt install xautomation<br>
4. INSTALL PACKAGE:# apt install jsonlint<br>
5. INSTALL PACKAGE:# apt install libgtk-3-bin<br>
* xautomation allows for bash script key emulation when using Expo applet to manage number of workspaces ( ctrl + alt + up ).
  If attempt is made to exceed MAX NUMBER OF WORKSPACES ( you set MAX in z_login.sh, see up above ), a dconf write to number of workspaces is made to hold MAX, and ESC key press is emulated to close the Expo page.<br>
* jsonlint checks the integrity of json files.<br>
* libgtk-3-bin provides gtk-launch for launching .desktop files from a terminal.<br> 
<br>


----------------------------------------------
Copy A Few Files In
----------------------------------------------
<br>

1. Copy 11_cinnamon.gschema.override into /usr/share/glib-2.0/schemas.<br>Then as su/sudo run this in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/<br>
2. Copy /etc/xdg/autostart/z_login.desktop into /etc/xdg/autostart/. This calls a script (z_login.sh) that runs per user $EUID at login.<br>
3. Make a directory: /usr/share/customscripts and copy the files z_login.sh and 9999.json into it.<br>
 (9999.json is just a modified to my requirements copy of /usr/share/cinnamon/applets/Cinnamenu@json/4.0/settings-schema.json). You might want change 4.0 to 5.8 on later Cinnamon versions or if using actual Mint.<br> You also might want your own default Cinnamenu configuration ( custom layout, what appears, etc ) just change settings-schema.json to what you want and also save as a new 9999.json .<br>
4. terminal:# chmod +x /usr/share/customscripts/z_login.sh.
<br>

----------------------------------------------------------------------------------------------------
IMPERATIVE FOR STABILITY !!!<br>
Remove "Add Panel", "Remove Panel" and "Remove Applet" Functions Entirely
----------------------------------------------------------------------------------------------------

Take a backup of /usr/share/cinnamon/js/panel.js, main.js, applet.js, everything, etc in case you need to restore them.<br>
EVEN WITH A BROKEN PANEL YOU CAN RIGHT-CLICK->RUN IN TERMINAL:# nemo, COPY/PASTE/RENAME BACKUPS ( ...edit as root ).
<br>
<br>

Do these as su/sudo:<br><br>
*** This deletes "(Panel Right-Click) Remove Panel" ***<br>
sed -i 's|menu.addMenuItem(menuItem);||g' /usr/share/cinnamon/js/ui/panel.js <br><br>

*** This deletes "(Panel Right-Click) Add Panel" ***<br>
sed -i 's|menu.addMenuItem(menu.addPanelItem);||g' /usr/share/cinnamon/js/ui/panel.js <br><br>

*** This deletes "(Panel Right-Click) Applets" ***<br>
sed -i 's|this.addMenuItem(applet_settings_item);||g' /usr/share/cinnamon/js/ui/panel.js <br><br>

*** This deletes "(Panel Right-Click) Panel Edit Mode" ***<br>
sed -i 's|menu.addMenuItem(panelEditMode);||g' /usr/share/cinnamon/js/ui/panel.js <br><br>

*** This deletes "(Panel Right-Click) System Settings" ***<br>
sed -i 's|this.addMenuItem(new SettingsLauncher(_("System Settings"), "", "preferences-desktop"));||g' /usr/share/cinnamon/js/ui/panel.js <br><br>

*** This deletes "(Panel Right-Click) Troubleshooting" ***<br>
sed -i 's|menu.addMenuItem(menu.troubleshootItem);||g' /usr/share/cinnamon/js/ui/panel.js <br><br>

*** This deletes "(Panel Right-Click) Remove {Applet By Name]" ***<br>
sed -i "s|this._applet_context_menu.addMenuItem(this.context_menu_item_remove);||g" /usr/share/cinnamon/js/ui/applet.js <br><br>  

*** This deletes "Add new panel (From Panel Settings)" ***<br>
sed -i 's|self.sidePage.add_widget(page)||g' /usr/share/cinnamon/cinnamon-settings/modules/cs_panel.py<br><br>

rm /usr/share/applications/cinnamon-settings-applets.desktop <br>
rm /usr/share/applications/cinnamon-settings-desklets.desktop <br>
rm /usr/share/applications/cinnamon-settings-extensions.desktop <br>
rm /usr/share/applications/cinnamon-settings-workspaces.desktop <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_applets.py <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_desklets.py <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_extensions.py <br>
rm /usr/share/cinnamon/cinnamon-settings/modules/cs_workspaces.py <br>

--------------------------------------------------------
To Change The MAX Number Of Workspaces A User May Create
--------------------------------------------------------

<br>
Set the value in z_login.sh by changing both the numbers under this line (4 is default):<br>
############ SET MAX NUMBER OF WORKSPACES HERE ###############<br>
if [ "$wksp" -gt 4 ];then<br>
dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces "4".<br>
<br>
<br>
<br>

-------------------------------------------------------------------------------------------------------------------------
What To Do If You Have Different Panel Applets (/usr/share/cinnamon/applets/)<br>To Those In /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override
-------------------------------------------------------------------------------------------------------------------------

<br>
Change them in this 11_cinnamon.gschema.override file, and ensure you copy and paste the array directly from that file into function_resetcinnamenu
in /usr/share/customscripts/z_login.sh. <br>
Run again as su/sudo in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/
<br>
<br>
Here Is The Current Array So You May Compare If All These Applets Are Currently In Your /usr/share/cinnamon/applets Folder:
<br>
<br>
enabled-applets=[ 'panel1:center:0:Cinnamenu@json', 'panel1:left:0:workspace-switcher@cinnamon.org' , 'panel1:left:1:grouped-window-list@cinnamon.org', 'panel1:right:0:systray@cinnamon.org', 'panel1:right:1:xapp-status@cinnamon.org', 'panel1:right:2:notifications@cinnamon.org', 'panel1:right:3:printers@cinnamon.org', 'panel1:right:4:removable-drives@cinnamon.org', 'panel1:right:5:keyboard@cinnamon.org', 'panel1:right:6:favorites@cinnamon.org', 'panel1:right:7:network@cinnamon.org', 'panel1:right:8:sound@cinnamon.org', 'panel1:right:9:power@cinnamon.org', 'panel1:right:10:calendar@cinnamon.org' ]
<br>
<br>
<br>
<br>
<br>
<br>

------------------------------------------
You Are Up & Running
------------------------------------------
---------------------------------------------------------------------------------------------------------------
What Happens At Next Login Of The Very First Ever Created User ?<br> ( The user account created as part of OS setup/install )
---------------------------------------------------------------------------------------------------------------
<br>
1. /etc/xdg/autostart/z_login.desktop calls script /usr/share/customscripts/z_login.sh, which does the following:
<br>
2. The first user that was created during setup/install - when logging out and back in for the very first time<br>- a check is made for a filename: ~/.config/firstlogincomplete_DONOTDelete.<br>
3. This filename ~/.config/firstlogincomplete_DONOTDelete won't be there yet, because of missing filename the<br>Cinnamenu schema file 9999.json will be copied into ~/.config/cinnamon/spices/Cinnamenu@json/, and a dconf write will enable the default applets - including Cinnamenu.<br>
4. Auto forced logging out will happen just this once by: cinnamon-session-quit --logout --force <br>
5. The file ~/.config/firstlogincomplete_DONOTDelete will be created so going forward that file is found and so during future logins it's triggers/functions/forced logout (all get skipped).<br>
6. Now your first ever user that was created during first setup/install when logging in again next time and going forward gets Cinnamenu.

-----------------------------------------------------
What Happens At Login Of Subsequently Created Users?
-----------------------------------------------------

Subsequently created users will get Cinnamenu as default.<br>
They will also be automatically logged out once, only, and never again because the file ~/.config/firstlogincomplete_DONOTDelete will be created.

----------------------------------
What Happens At Every Other Login?
----------------------------------

At every login we run jsonlint to check the integrity of 9999.json.<br>If the file fails, it will be copied in from and overwritten by /usr/share/customscripts/9999.json<br>
Also, if for some strange reason the file is missing it ( 9999.json ) will also be copied in from and overwritten.

---------------------------------------------------------------------------
What Happens During An Apt Update/Upgrade To The Cinnamon Desktop Version?
---------------------------------------------------------------------------
Cinnamenu@json will be deleted and has to be downloaded and added again into /usr/share/cinnamon/applets/



You will note other non-relevant stuff in z_login.sh I have left there for educational purposes.<br><br>
Have a good day and try and be nice to others :)
<br><br>

---END OF README---
