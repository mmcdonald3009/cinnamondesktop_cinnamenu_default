------------------------------------------------------------------------
Cinnamenu Default Menu On A Single Moveable Cinnamon Desktop Panel
------------------------------------------------------------------------
WHAT THIS DOES


1. Very simple to implement solution for making Cinnamenu the default menu, on a single cinnamon desktop panel.
2. Another feature - when a user toggles Show Hidden Files in Nemo, Nemo will immediately close and restart. Not a perfect solution but should keep kids from accidentally deleting hidden files.
3. And also you can set a limit to the number of workspaces a user may create.
4. Some panel functions-> User Add/Remove Panels & Add/Remove Applets, Desklets and Extensions should be deleted for stability - procedures down below. I can't make you, but only with that done will you get the desired "user unbreakability".
5. There is a section below addressing how to implement custom applets system-wide:<br> "What If I Want Different Applets In (/usr/share/cinnamon/applets/)
To Those In /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override ?"
6. The ability to Move the single panel is retained.
7. Nothing is dangerous when everything is considered and managed in proper context.


I delete the Add & Remove panel and applet/desklet/extension functions because I wanted something I could deploy mainstream requiring minimal user support which means removing anything unnecessary that could break it.

If you want a viable alternative to Mac or Windoze, one stable moveable panel should suffice.

Note, I make Cinnamenu an applet in the OS system /usr/share/cinnamon/applets folder as opposed to an applet in the users home hidden folders - where it might otherwise get "accidentally while I was chowing down on a pizza" deleted. 

Should work on most distros as there really isn't much to it. Relies on the gnome functions that lets you call a per user login script from a .desktop file in /etc/xdg/autostart, the gschema override function, and dbus-monitor to detect app calls that change state of things, and respond with (dconf write, etc ) from script if required.


I am using SpiralLinux Debian 12.6 Cinnamon, which formats FS to BTRFS and has snapper rollback in the GRUB menu !


Also tested on LMDE Mint.


Many many thanks to the GeckoLinux dev for coming up with the amazing SpiralLinux.

https://spirallinux.github.io/#download


------------------------------------------
( How To: 1 of 3 ) Download & Install These
------------------------------------------


1. Download Cinnamenu - was here at time of writing: https://cinnamon-spices.linuxmint.com/applets/view/322
2. Copy all the Cinnamenu@json folders & files into /usr/share/cinnamon/applets/Cinnamenu@json
3. Do:# apt update && upgrade to make sure you have current repos to get the following files...
4. Install:# apt install xautomation
5. Install:# apt install libgtk-3-bin

* xautomation allows for keypress emulation from a script.

* libgtk-3-bin provides gtk-launch for launching .desktop files from a script.


--------------------------------------------------------------------------------------------
( How To: 2 of 3 ) Copy In The Files Provided By This Github Project
--------------------------------------------------------------------------------------------


1. Copy provided /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override into your system folder /usr/share/glib-2.0/schemas/
2. As su/sudo run this in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/
3. Copy provided /etc/xdg/autostart/z_login.desktop into your system folder /etc/xdg/autostart/. This runs at userlogin to execute the script->(/usr/share/customscripts/z_login.sh)
4. Make a system folder: /usr/share/customscripts and copy in the provided /usr/share/customscripts/z_login.sh
5. Make sure group: ( others have read & execute permissions)
6. Have a look around inside z_login.sh and note the functions ...
7. Make z_login.sh executable from terminal:# chmod +x /usr/share/customscripts/z_login.sh
8. Check all your permissions again( 755 is good )
9. This is all that is actually required to make the core work. However, be sure to remove unnecessary Panel functions as per next section below !


----------------------------------------------------------------------------------------------------
( How To: 3 of 3 ) Delete "Add Panel", "Remove Panel" and "Remove Applets, etc" Functions Entirely<br>
*** YOU REALLY GOTTA DO THESE FOR THE UNBREAKABILITY/STABILITY
----------------------------------------------------------------------------------------------------


Take a backup of /usr/share/cinnamon/js/panel.js, main.js, applet.js, everything, etc in case you want to restore them.<br>
EVEN WITH A BROKEN PANEL YOU CAN RIGHT-CLICK->RUN IN TERMINAL:# nemo, COPY/PASTE/RENAME BACKUPS ( ...edit as root ).


Copy/Paste these lines (not the ones beginning with ***, the ones below starting with 'sed' - and then the lines beginning with 'rm' ) all as su/sudo in a terminal:#


*** This deletes "(Panel Right-Click) Remove Panel" ***

sed -i 's|menu.addMenuItem(menuItem);||g' /usr/share/cinnamon/js/ui/panel.js


 
*** This deletes "(Panel Right-Click) Add Panel" ***

sed -i 's|menu.addMenuItem(menu.addPanelItem);||g' /usr/share/cinnamon/js/ui/panel.js



*** This deletes "(Panel Right-Click) Applets" ***

sed -i 's|this.addMenuItem(applet_settings_item);||g' /usr/share/cinnamon/js/ui/panel.js



*** This deletes "(Panel Right-Click) Panel Edit Mode" ***

sed -i 's|menu.addMenuItem(panelEditMode);||g' /usr/share/cinnamon/js/ui/panel.js



*** This deletes "(Panel Right-Click) System Settings" ***

sed -i 's|this.addMenuItem(new SettingsLauncher(_("System Settings"), "", "preferences-desktop"));||g' /usr/share/cinnamon/js/ui/panel.js



*** This deletes "(Panel Right-Click) Troubleshooting" ***

sed -i 's|menu.addMenuItem(menu.troubleshootItem);||g' /usr/share/cinnamon/js/ui/panel.js



*** This deletes "(Panel Right-Click) Remove {Applet By Name]" ***

sed -i "s|this._applet_context_menu.addMenuItem(this.context_menu_item_remove);||g" /usr/share/cinnamon/js/ui/applet.js


*** This deletes "Add new panel (From Panel Settings)" ***

sed -i 's|self.sidePage.add_widget(page)||g' /usr/share/cinnamon/cinnamon-settings/modules/cs_panel.py




And do these removes all as su/sudo in a terminal:#

rm /usr/share/applications/cinnamon-settings-applets.desktop


rm /usr/share/applications/cinnamon-settings-extensions.desktop


rm /usr/share/cinnamon/cinnamon-settings/modules/cs_applets.py


rm /usr/share/cinnamon/cinnamon-settings/modules/cs_extensions.py





-------------------------------------------------------------------------------------------------------------------------
What If I Want Different Applets In (/usr/share/cinnamon/applets/)<br>To Those In /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override ?
-------------------------------------------------------------------------------------------------------------------------


Change them to match in /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override.

Then again as su/sudo run in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/


------------------------------------------
At This Stage You Are Up & Running...
------------------------------------------


---------------------------------------------------------------------------------------------------------------
What Happens At Next Login Of The Very First Ever Created User ?<br> ( The user account created as part of OS setup/install )
---------------------------------------------------------------------------------------------------------------

1. /etc/xdg/autostart/z_login.desktop calls script /usr/share/customscripts/z_login.sh
2. Script checks for a filename( ~/.config/firstlogincomplete_DONOTDelete ), this file will be missing and by being missing triggers some actions...
3. Trigger action: Set Cinnamenu@json applet as the default Menu
4. Filename ~/.config/firstlogincomplete_DONOTDelete will then get created, so going forward trigger functions not applied again unless you delete that file
5. These here 3 commands ( along with the gschema override file you copied in and command function you ran earlier ) do the work of enabling Cinnamenu to be the default:
* gsettings reset org.cinnamon panels-enabled
* gsettings reset-recursively org.cinnamon
* cinnamon --replace &

-----------------------------------------------------
What Happens At Login Of Subsequently Created Users?
-----------------------------------------------------

Same as what happens at next login of the very first ever created user.

-----------------------------------------------------
Adjusting / Fixing
-----------------------------------------------------

1. If you don't want the max workspaces limit and Nemo disable hidden files, comment out the last line in z_login.sh
2. You can stop Nemo Show Hidden Files closing/restarting & Workspace Max Number Limiting by typing this in terminal:# killall dbus-monitor
3. To Change The MAX Number Of Workspaces A User May Create:
Set the value in z_login.sh by changing both the numbers under this line (4 is default)
############ SET MAX NUMBER OF WORKSPACES HERE ###############<br>
if [ "$wksp" -gt 4 ];then<br>
dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces "4".

Cinnamenu appears in panel centre. If you want it in another position, change applet position settings in 11_cinnamon.gschema.override:
'panel1:center:0:Cinnamenu@json'- and remember as su/sudo to do this again in terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/

If you have done all the 'sed' and 'rm' to remove certain Panel functions, you shouldn't have any issues.

However if you get a smarty who uses the terminal to access hidden files and "accidentally" deletes ~/.config/cinnamon/spices/Cinamenu@json or the .json file that should be there,
then in a terminal type:# rm ~/.config/firstlogincomplete_DONOTDelete and have them logout and login again and everything resets.

When you create a user, if the Cinnamenu does not toggle as default on first login - it does work if you:
* Manual logout and then it works at every login afterwards
* Setup forced logout by default after the first login - and then it works at every login afterwards by:
uncommenting cinnamon-session-quit --logout --force in /usr/share/customscripts z_login.sh

Forced logout may have to be the norm in future wayland implementations I have not tested as muffin wayland at this time is experimental.

-----------------------------------------------------------------------------------
What Happens To The Cinnamon Desktop During An Apt Upgrade To The Library/Version ?
-----------------------------------------------------------------------------------


Cinnamenu@json could get deleted and have to be downloaded and copied again into /usr/share/cinnamon/applets/

Don't be funny and chattr +i the folder, it might cause your entire update/upgrade to fail.

Trust me, I tried it...


-----------------------------------------------------------------------------------
Not related But Maybe Useful Knowledge: Display Manager - LightDM or GDM3?
-----------------------------------------------------------------------------------
The issue may be that I am using Debian. Both cinnamon-settings-users and users-admin ( gnome-system-tools ) have problems deleting users when running under LightDM.
However, they work properly when GDM3 is the display manager.

Have a good day and try and be nice to others :)


---END OF README---
