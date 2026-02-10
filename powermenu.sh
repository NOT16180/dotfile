#!/bin/bash

# Définition des options avec leurs icônes
options="  Lock\n Shutdown\n Reboot"

# Affichage du menu dmenu et capture de la sélection
selected=$(echo -e "$options" | dmenu -i -p "Session:")

# Exécution de l'action correspondante
case $selected in
"  Lock")
	hyprlock
	;;
" Shutdown")
	systemctl poweroff
	;;
" Reboot")
	reboot
	;;
esac
