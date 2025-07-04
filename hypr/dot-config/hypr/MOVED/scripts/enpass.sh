#!/usr/bin/env bash

set_enpass_mime() {

    local set_mime_type_cmd
    local from_brave_search

    from_brave_search="
	Search engine: https://search.brave.com
	Search terms: linux register mime type enpassstart:///
Register Linux Mime Type
To register a MIME type like enpassstart:/// for an application in Linux, you need to follow
several steps. First, ensure that the desktop-file-utils and shared-mime-info packages are
installed on your system. These packages are necessary for managing MIME types and desktop entries.

Next, you should create a .desktop file for your application if you don't already have one.
This file should include the MIME type you want to register. For example, if you are registering
the enpassstart:/// MIME type, your .desktop file might look like this:

[Desktop Entry]
Version=1.0
Type=Application
Name=Enpass
GenericName=Enpass Password Manager
Icon=enpass
Terminal=false
Exec=/opt/enpass/Enpass %U
MimeType=x-scheme-handler/enpassstart
Categories=Utility
After creating the .desktop file, place it in /usr/share/applications/ for system-wide registration
or ~/.local/share/applications/ for a user-specific registration.

To associate the MIME type with your application, you can use the xdg-mime command. For example,
to set enpassstart:/// to open with the Enpass application, you can use:

xdg-mime default Enpass.desktop x-scheme-handler/enpassstart
This command sets the default application for the enpassstart:/// MIME type to be Enpass. Make sure
to replace Enpass.desktop with the actual path to your .desktop file if it is not in the default
location.

Finally, update the MIME database to ensure that your changes take effect:

update-mime-database /usr/share/mime
For more detailed steps and examples, you can refer to the documentation on registering applications
for MIME types in GNOME 2.2 Desktop on Linux System Administration Guide
 and the Arch Linux forums for additional guidance
"

    set_mime_type_cmd="xdg-mime default Enpass.desktop x-scheme-handler/enpassstart"

    if [[ "${1}" = "info" ]]; then
        printf "%b" "${from_brave_search}"
    elif [[ "${1}" = "" ]]; then
        printf "Running\n%b \nto fix Enpass enpassstart:/// opening and erroring out inside different browser\nthan the one Enpass was called from." "${set_mime_type_cmd}"
        ${set_mime_type_cmd}
    else
        echo error
    fi
}
set_enpass_mime "${@}"
