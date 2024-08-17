------------------------------------------------------------------------
Cinnamenu As Default Menu On A Single Moveable Cinnamon Desktop Panel
------------------------------------------------------------------------
WHAT THIS DOES
<br>
1. Sets Cinnamenu as the default menu for new users, on a single cinnamon desktop panel.<br>
2. Some panel functions like Add Panel and Remove Panel get deleted for stability - procedures are below. We do, however keep the ability to Move the single panel.<br>
3. Nothing is dangerous when everything is considered in it's proper context.<br>
4. When a user toggles Show Hidden Files in Nemo, Nemo will immediately close and restart. Not a perfect solution but should keep kids from accidentally deleting hidden files.<br>
5. You can set a limit to the number of workspaces a user may create.<br>
<br>
<br>
A quick about me so you have some context for the logic I apply in deciding what I think is suitable for a mainstream deployment:<br><br>
1. I am a trades qualified Electrical Mechanic in the state of NSW, Australia (Otis Elevators, 1990).<br>
2. My IT career began with running a small computer shop at the back of a BP petrol station in Tennant Creek, Northern Territory, outback Australia in 1996.<br>There, 
I was servicing Novell and early NT networks in gold mine offices and on aboriginal council office and educational centres.<br>
3. I moved to Sydney in 1998 and took on team contract roles that were being made available due to WIN NT market driving and vacancies as seniors moved into y2k remediation projects.<br>
4. I spent time on integration projects involving Windows NT 4.0, Lotus Notes To Exchange, etc...<br>
5. I was an IT systems (AD 2000, Citrix Metaframe) admin for the AMTL/Connex JV in Melbourne when they held the commuter train franchise there in the early 2000's.<br>
6. I have also worked in property construction and building/facilities operations management.<br>
7. I started coding PHP and JS and playing with Linux in 2006 and developed successful business applications in Laravel and vanilla PHP/js.

<br><br>
I have stripped the Add & Remove panel functions because I wanted something I could deploy mainstream requiring minimal user support by removing anything that could break it.<br>
If you want to a viable alternative to Mac or Windoze, imho you actually only need one stable moveable panel.
Note I make Cinnamenu an applet in the main /usr/share/cinnamon/applets folder as opposed to an applet in the users home hidden folders. 

<br>
At time of writing I am using Debian 12.6. Do an apt update && upgrade to make sure you are current.<br>Also works fine on LMDE Mint.<br>
Should work on most distros as there isn't much to it and relies mostly on the gnome function that lets you can call a per user login script from a .desktop file in /etc/xdg/autostart<br><br>
I am using SpiralLinux which formats as BTRFS and has snapper rollback in the GRUB menu !<br>
Many Many thanks to the OpenSUSE GeckoLinux dev for coming up with SpiralLinux.<br>
https://spirallinux.github.io/#download
<br>
<br>
<br>


------------------------------------------
Download & Install These
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
Copy My Provided Files (here ... this github download them) Into Place
----------------------------------------------
<br>

1. Copy provided /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override into your file system /usr/share/glib-2.0/schemas/<br>Then as su/sudo run this in a terminal:# glib-compile-schemas /usr/share/glib-2.0/schemas/<br>
2. Copy provided /etc/xdg/autostart/z_login.desktop into your file system /etc/xdg/autostart/. This runs at userlogin and calls a script (/usr/share/customscripts/z_login.sh)<br>
3. Make a directory: /usr/share/customscripts ( make sure group: others can read & execute permissions), and copy the provided /usr/share/customscripts/z_login.sh into it<br>
4. Make z_login.sh executable by run in terminal:# chmod +x /usr/share/customscripts/z_login.sh
5. Check all your permissions
6. This is all that is actually required to make the core work. However, be sure to remove unnecessary Panel functions as per next section below !

<br>

----------------------------------------------------------------------------------------------------
Delete "Add Panel", "Remove Panel" and "Remove Applet" Functions Entirely...
YOU REALLY SHOULD DO THESE FOR UNBREAKABILITY & STABILITY ...<br>
The default set released as part of Cinnamon stable is enough for a productive computing experience.
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
2. Script checks for a filename( ~/.config/firstlogincomplete_DONOTDelete ) which will be missing and being missing triggers some actions...<br>
3. Trigger action: Enable Default Applets - Set Cinnamenu@json applet As The Default Main Menu<br>
4. Filename ~/.config/firstlogincomplete_DONOTDelete will now get created, so going forward trigger function not applied again<br>

-----------------------------------------------------
What Happens At Login Of Subsequently Created Users?
-----------------------------------------------------

Same as what happens at next login of the very first ever created user.<br>

<br>

-----------------------------------------------------
Fixing / Adjusting
-----------------------------------------------------
<br>
If you have done all the 'sed' and 'rm' to remove certain Panel functions, you shouldn't have any issues.
However if you get a smarty who uses the terminal to access hidden files and "accidentally" deletes ~/.config/cinnamon/spices/Cinamenu@json or the .json file that should be there,<br>
then in a terminal type:# rm ~/.config/firstlogincomplete_DONOTDelete and have them logout and login again and everything resets.<br><br>
- You can stop Nemo Show Hidden Files closing/restarting & Workspace Max Number Limiting by typing this into a terminal:# killall dbus-monitor<br>
- If you don't want the max workspaces limit and Nemo disable hidden files, comment out the last line in z_login.sh


-----------------------------------------------------------------------------------
What Happens To The Cinnamon Desktop During An Apt Upgrade To The Library/Version ?
-----------------------------------------------------------------------------------
Cinnamenu@json will get deleted and have to be downloaded and copied again into /usr/share/cinnamon/applets/
<br><br>
Have a good day and try and be nice to others :)
<br><br>

-----------------------------------------------------------------------------------
Not related But Maybe Useful Knowledge Display Manager - LightDM or GDM3?
-----------------------------------------------------------------------------------
The issue may be that I am using Debian. Both cinnamon-settings-users and users-admin ( gnome-system-tools ) have problems deleting users when running LightDM.
They work properly running on GDM3.


---END OF README---
