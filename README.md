------------------------------------
Cinnamenu As Default Menu On A Single Moveable Cinnamon Desktop Panel
------------------------------------
<br>
1. Sets Cinnamenu as the default menu for new users, on a single cinnamon desktop panel.<br>
2. Some panel functions like Add Panel and Remove Panel REALLY SHOULD be deleted for stability - procedures are below. We do, however keep the ability to move the single panel.<br>
3. Nothing is dangerous when everything is considered in it's proper context.<br>
4. When a user toggles Show Hidden Files in Nemo, Nemo will immediately close and restart. Not a perfect solution but should keep kids from accidentally deleting hidden files.<br>
5. You can set a limit to the number of workspaces a user may create.<br>
6. At anytime you can stop Nemo Show Hidden Files closing/restarting & Workspace Max Number Limiting by typing into a terminal:# killall dbus-monitor
<br>Logout and then Login and they will be running again. 
<br>
<br>
At time of writing I am using Debian 12.6, this is the minimum so DO an apt update && upgrade to make sure you are current. Works fine on Mint.<br><br>
I am using SpiralLinux which formats as BTRFS and has snapper rollback in the GRUB menu !<br>
Many Many thanks to the OpenSUSE GeckoLinux dev for coming up with SpiralLinux.<br>
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
* xautomation allows for keypress emulation from a script.<br>
* libgtk-3-bin provides gtk-launch for launching .desktop files from a terminal.<br> 
<br>


----------------------------------------------
Copy Provided Files Into Place
----------------------------------------------
<br>

1. Copy provided /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override into your file system /usr/share/glib-2.0/schemas/.<br>Then as su/sudo run this in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/<br>
2. Copy provided /etc/xdg/autostart/z_login.desktop into your file system /etc/xdg/autostart/. This runs at userlogin and calls a script (/usr/share/customscripts/z_login.sh).<br>
3. Make a directory: /usr/share/customscripts ( make sure group: others can read & execute permissions), and copy the provided /usr/share/customscripts/z_login.sh into it.<br>
4. Make z_login.sh executable by run in terminal:# chmod +x /usr/share/customscripts/z_login.sh.
5. This is all that is actually required to make it work. However, be sure to remove Panel functions as per next below.
6. Check all your permissions.
<br>

----------------------------------------------------------------------------------------------------
Remove "Add Panel", "Remove Panel" and "Remove Applet" Functions Entirely
YOU REALLY SHOULD DO THESE FOR UNBREAKABILITY & STABILITY ...<br>
----------------------------------------------------------------------------------------------------
<br>
Take a backup of /usr/share/cinnamon/js/panel.js, main.js, applet.js, everything, etc in case you need to restore them.<br>
EVEN WITH A BROKEN PANEL YOU CAN RIGHT-CLICK->RUN IN TERMINAL:# nemo, COPY/PASTE/RENAME BACKUPS ( ...edit as root ).
<br>
<br>

Copy/Paste these lines (not the ones beginning with ***, the ones below starting with 'sed' - and then the lines beginning with 'rm' ) all as su/sudo in a terminal:#<br><br>
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
And do these removes...<br>
The default set is good enough for productive computing and released as part of Cinnamon stable, so no real need to change:
<br>
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
Change them to match in /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override.<br>
Then again as su/sudo run in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/
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
1. /etc/xdg/autostart/z_login.desktop calls script /usr/share/customscripts/z_login.sh<br>
2. Script checks for a filename( ~/.config/firstlogincomplete_DONOTDelete ) which will be missing and that triggers some actions<br>
3. Trigger action: Enable Default Applets - Set Cinnamenu@json applet As The Default Main Menu<br>
4. Filename ~/.config/firstlogincomplete_DONOTDelete will now get created, so going forward trigger function not applied again<br>

-----------------------------------------------------
What Happens At Login Of Subsequently Created Users?
-----------------------------------------------------

Same as what happens at next login of the very first ever created user.<br>

<br>

-----------------------------------------------------
Fixing Procedure
-----------------------------------------------------
<br>
If you have done all the 'sed' and 'rm' to remove certain Panel functions, you shouldn't have any issues.
However if you get a smarty who uses the terminal to access hidden files and "accidentally" deletes ~/.config/cinnamon/spices/Cinamenu@json or the .json file that should be there,<br>
then in a terminal type:# rm ~/.config/firstlogincomplete_DONOTDelete and have them logout and login again and everything resets.


---------------------------------------------------------------------------
What Happens To The Cinnamon Desktop During An Apt Upgrade To The Library/Version ?
---------------------------------------------------------------------------
Cinnamenu@json will get deleted and have to be downloaded and copied again into /usr/share/cinnamon/applets/
<br><br>
Have a good day and try and be nice to others :)
<br><br>

---END OF README---
