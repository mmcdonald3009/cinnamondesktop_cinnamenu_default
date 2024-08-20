------------------------------------------------------------------------
Cinnamenu As Default Menu On A Single Moveable Cinnamon Desktop Panel
------------------------------------------------------------------------
WHAT THIS DOES
<br>
1. Sets Cinnamenu as the default menu for new users, on a single cinnamon desktop panel.
<br>
2. When a user toggles Show Hidden Files in Nemo, Nemo will immediately close and restart. Not a perfect solution but should keep kids from accidentally deleting hidden files.
<br>
3. You can set a limit to the number of workspaces a user may create.
<br>
4. Some panel functions like Add and Remove Panels & Add/Remove Applets should get deleted for stability - procedures are below. We do, however keep the ability to Move the single panel.
<br>
5. Nothing is dangerous when everything is considered in it's proper context.
<br>

<br>
I delete the Add & Remove panel and applet/desklet/extension functions because I wanted something I could deploy mainstream requiring minimal user support by removing anything unnecessary that could break it.<br>
If you want a viable alternative to Mac or Windoze, you actually only require one stable moveable panel.<br><br>
The default applets/desklets set released as part of Cinnamon stable are enough for a productive computing experience, without adding more or deleting any.
<br><br>
Note, I make Cinnamenu an applet in the OS system /usr/share/cinnamon/applets folder as opposed to an applet in the users home hidden folders. 
<br>
<br>
At time of writing I am using Debian 12.6. Do an apt update && upgrade to make sure you are current.<br>Also tested on LMDE Mint.
<br><br>
Should work on most distros as there really isn't much to it. Relies mostly on the gnome function that lets you call a per user login script from a .desktop file in /etc/xdg/autostart
and the gschema override function.
<br><br>
I am using SpiralLinux Debian Cinnamon, which formats FS to BTRFS and has snapper rollback in the GRUB menu !
<br>
<br>
Many Many thanks to the OpenSUSE GeckoLinux dev for coming up with SpiralLinux.
<br>
https://spirallinux.github.io/#download
<br>
<br>
<br>


------------------------------------------
( How To: 1 of 3 ) Download & Install These
------------------------------------------
<br>

1. Download Cinnamenu - was here at time of writing: https://cinnamon-spices.linuxmint.com/applets/view/322
<br>
2. Copy the Cinnamenu@json files into /usr/share/cinnamon/applets/Cinnamenu@json/
<br>
3. INSTALL PACKAGE:# apt install xautomation
<br>
4. INSTALL PACKAGE:# apt install libgtk-3-bin
<br>
* xautomation allows for keypress emulation from a script.
<br>
* libgtk-3-bin provides gtk-launch for launching .desktop files from a terminal.
<br> 
<br>


--------------------------------------------------------------------------------------------
( How To: 2 of 3 ) Copy In My Provided Files (yes from this github download them !)
--------------------------------------------------------------------------------------------
<br>

1. Copy provided /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override into your file system /usr/share/glib-2.0/schemas/<br>Then as su/sudo run this in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/
<br>
2. Copy provided /etc/xdg/autostart/z_login.desktop into your file system /etc/xdg/autostart/. This runs at userlogin and calls a script (/usr/share/customscripts/z_login.sh)
<br>
3. Make a directory: /usr/share/customscripts ( make sure group: others can read & execute permissions), and copy the provided /usr/share/customscripts/z_login.sh into it
<br>
4. Have a look around inside z_login.sh and note the functions ...
<br> 
5. Make z_login.sh executable by run in terminal:# chmod +x /usr/share/customscripts/z_login.sh<br>
5. Check all your permissions( 755 is usually good )<br>
6. This is all that is actually required to make the core work. However, be sure to remove unnecessary Panel functions as per next section below !<br>

<br>

----------------------------------------------------------------------------------------------------
( How To: 3 of 3 ) Delete "Add Panel", "Remove Panel" and "Remove Applet" Functions Entirely...
YOU REALLY GOTTA DO THESE FOR THE UNBREAKABILITY/STABILITY ...<br>
----------------------------------------------------------------------------------------------------
<br>
Take a backup of /usr/share/cinnamon/js/panel.js, main.js, applet.js, everything, etc in case you want to restore them.<br>
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
And do these removes...
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



-------------------------------------------------------------------------------------------------------------------------
What To Do If Using Different Panel Applets (/usr/share/cinnamon/applets/)<br>To Those In /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override ?
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
2. Script checks for a filename( ~/.config/firstlogincomplete_DONOTDelete ) which will be missing and being missing triggers some actions...<br>
3. Trigger action: Enable Default Applets - Set Cinnamenu@json applet As The Default Main Menu<br>
4. Filename ~/.config/firstlogincomplete_DONOTDelete will now get created, so going forward trigger function not applied again<br>

-----------------------------------------------------
What Happens At Login Of Subsequently Created Users?
-----------------------------------------------------

Same as what happens at next login of the very first ever created user.<br>

<br>

-----------------------------------------------------
Adjusting / Fixing
-----------------------------------------------------
<br>
* You can stop Nemo Show Hidden Files closing/restarting & Workspace Max Number Limiting by typing this in terminal:# killall dbus-monitor<br>
* If you don't want the max workspaces limit and Nemo disable hidden files, comment out the last line in z_login.sh<br>
* To Change The MAX Number Of Workspaces A User May Create:<br>
Set the value in z_login.sh by changing both the numbers under this line (4 is default)<br>
############ SET MAX NUMBER OF WORKSPACES HERE ###############<br>
if [ "$wksp" -gt 4 ];then<br>
dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces "4".
<br><br>
Cinnamenu appears in panel centre. If you want it in another position, change in 11_cinnamon.gschema.override:
'panel1:center:0:Cinnamenu@json',
And remember as su/sudo to do this in terminal:#glib-compile-schemas /usr/share/glib-2.0/schemas/
<br><br>
If you have done all the 'sed' and 'rm' to remove certain Panel functions, you shouldn't have any issues.
However if you get a smarty who uses the terminal to access hidden files and "accidentally" deletes ~/.config/cinnamon/spices/Cinamenu@json or the .json file that should be there,<br>
then in a terminal type:# rm ~/.config/firstlogincomplete_DONOTDelete and have them logout and login again and everything resets.
<br><br>
When you create a user, if the Cinnamenu does not toggle as default on first login - it does work if you:<br>
* Manual logout and then it works at every login afterwards<br>
* Setup forced logout by default after the first login - and then it works at every login afterwards by:<br>
uncommenting cinnamon-session-quit --logout --force in /usr/share/customscripts z_login.sh<br><br>
Forced logout may have to be the norm in future wayland implementations I have not tested as muffin wayland at this time is exmperimental anyway.
<br><br>


-----------------------------------------------------------------------------------
What Happens To The Cinnamon Desktop During An Apt Upgrade To The Library/Version ?
-----------------------------------------------------------------------------------
Cinnamenu@json will get deleted and have to be downloaded and copied again into /usr/share/cinnamon/applets/
<br><br>


-----------------------------------------------------------------------------------
Not related But Maybe Useful Knowledge: Display Manager - LightDM or GDM3?
-----------------------------------------------------------------------------------
The issue may be that I am using Debian. Both cinnamon-settings-users and users-admin ( gnome-system-tools ) have problems deleting users when running under LightDM.
However, they work properly when GDM3 is the display manager.
<br><br>
Have a good day and try and be nice to others :)
<br><br>

---END OF README---
