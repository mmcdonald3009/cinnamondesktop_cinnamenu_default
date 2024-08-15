------------------------------------
Cinnamenu As Default Menu On A Single Moveable Cinnamon Desktop Panel
------------------------------------
<br>
1. Sets Cinnamenu as the default menu for new users, on a single cinnamon desktop panel with panel keeping "Move" enabled.<br>
2. Some panel functions like Add Panel and Remove Panel HAVE to be deleted for stability - procedures are below.<br> Nothing is dangerous when everything is properly considered.<br>
3. When a user toggles hidden files in Nemo, Nemo simply closes and restarts.<br>Not a perfect solution but should keep kids from accidentally deleting hidden files.<br>
4. You can set a limit to the number of workspaces a user may create.<br>
5. At anytime you can stop (3 & 4 above ) by typing into a terminal:# killall dbus-monitor.
<br>Logout and then Login and they will be running again. 
<br>
<br>
At time of writing I am using Debian 12.6, this is the minimum so DO apt upgrade to make sure you are current.<br>
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
4. INSTALL PACKAGE:# apt install libgtk-3-bin<br>
* xautomation allows for bash script key emulation.<br>
* libgtk-3-bin provides gtk-launch for launching .desktop files from a terminal.<br> 
<br>


----------------------------------------------
Copy Provided Files Into Place
----------------------------------------------
<br>

1. Copy provided /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override into your file system /usr/share/glib-2.0/schemas/.<br>Then as su/sudo run this in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/<br>
2. Copy provided /etc/xdg/autostart/z_login.desktop into your file system /etc/xdg/autostart/. This runs at userlogin and calls a script (/usr/share/customscripts/z_login.sh).<br>
3. Make a directory: /usr/share/customscripts, and copy the provided /usr/share/customscripts/z_login.sh into it.<br>
4. Make z_login.sh executable by run in terminal:# chmod +x /usr/share/customscripts/z_login.sh.
5. This is all that is actually required to make it work.
<br>

----------------------------------------------------------------------------------------------------
IMPERATIVE - YOU MUST ALSO DO THESE FOR UNBREAKABILITY  / STABILITY !!!<br>
Remove "Add Panel", "Remove Panel" and "Remove Applet" Functions Entirely
----------------------------------------------------------------------------------------------------
<br>
Take a backup of /usr/share/cinnamon/js/panel.js, main.js, applet.js, everything, etc in case you need to restore them.<br>
EVEN WITH A BROKEN PANEL YOU CAN RIGHT-CLICK->RUN IN TERMINAL:# nemo, COPY/PASTE/RENAME BACKUPS ( ...edit as root ).
<br>
<br>

Copy/Paste these lines (not the ones with ***, the ones below starting with sed and then do the lines beginning with rm ) all as su/sudo in a terminal:#<br><br>
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
And do these removes:
<br>
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
What To Do If Using Different Panel Applets (/usr/share/cinnamon/applets/)<br>To Those In /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override
-------------------------------------------------------------------------------------------------------------------------

<br>
Change them in /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override, and copy and paste the array from that file into <br>
the function named function_resetcinnamenu in /usr/share/customscripts/z_login.sh. <br>
Run again as su/sudo in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/
<br>
<br>
Here Is The Provided Array For Comparison:
<br>
<br>
enabled-applets=[ 'panel1:center:0:Cinnamenu@json', 'panel1:left:0:workspace-switcher@cinnamon.org' , 'panel1:left:1:grouped-window-list@cinnamon.org', 'panel1:right:0:systray@cinnamon.org', 'panel1:right:1:xapp-status@cinnamon.org', 'panel1:right:2:notifications@cinnamon.org', 'panel1:right:3:printers@cinnamon.org', 'panel1:right:4:removable-drives@cinnamon.org', 'panel1:right:5:keyboard@cinnamon.org', 'panel1:right:6:favorites@cinnamon.org', 'panel1:right:7:network@cinnamon.org', 'panel1:right:8:sound@cinnamon.org', 'panel1:right:9:power@cinnamon.org', 'panel1:right:10:calendar@cinnamon.org' ]
<br>
<br>
<br>


------------------------------------------
At This Stage You Are Up & Running...
------------------------------------------
<br>

---------------------------------------------------------------------------------------------------------------
What Happens At Next Login Of The Very First Ever Created User ?<br> ( The user account created as part of OS setup/install )
---------------------------------------------------------------------------------------------------------------
<br>
1. /etc/xdg/autostart/z_login.desktop calls script /usr/share/customscripts/z_login.sh.<br>
2. A check is made for a filename( ~/.config/firstlogincomplete_DONOTDelete ) which will be missing and that triggers some actions.<br>
3. Trigger actions: Enable Default Applets Sets Cinnamenu As The Main Menu <br>
4. Auto forced logged out will happen just this once: cinnamon-session-quit --logout --force <br>
5. Filename ~/.config/firstlogincomplete_DONOTDelete will be created so going forward file is found at login,<br> and future triggers/functions/forced logout are all skippedas the file was found.<br>

-----------------------------------------------------
What Happens At Login Of Subsequently Created Users?
-----------------------------------------------------

Subsequently created users will also get Cinnamenu as default Menu.<br>
They will also be automatically logged out once, only, and then never again once the file ~/.config/firstlogincomplete_DONOTDelete has been created.


---------------------------------------------------------------------------
What Happens To The Cinnamon Desktop During An Apt Update/Upgrade To The Version ?
---------------------------------------------------------------------------
Cinnamenu@json will get deleted and have to be downloaded and copied again into /usr/share/cinnamon/applets/
<br><br>
Have a good day and try and be nice to others :)
<br><br>

---END OF README---
