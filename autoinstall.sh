#!/bin/bash

#############################################################################
#                                                                           #
# Project 'jexactyl-installer' for panel, edit of 'pterodactyl-installer'   #
# by Vilhelm Prytz https://github.com/vilhelmprytz/pterodactyl-installer    #
#                                                                           #
#                                                                           #
#   This program is free software: you can redistribute it and/or modify    #
#   it under the terms of the GNU General Public License as published by    #
#   the Free Software Foundation, either version 3 of the License, or       #
#   (at your option) any later version.                                     #
#                                                                           #
#   This program is distributed in the hope that it will be useful,         #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of          #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
#   GNU General Public License for more details.                            #
#                                                                           #
#   You should have received a copy of the GNU General Public License       #
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.  #
#                                                                           #
# https://github.com/Vasolix/jexactyl-installer/blob/master/LICENSE         #
#                                                                           #
# This script is not associated with the official Pterodactyl Project.      #
# https://github.com/linkea131/jexactyl-installer                             #
#                                                                           #
#############################################################################

SCRIPT_VERSION="v1.11.3.3"
GITHUB_BASE_URL="https://raw.githubusercontent.com/linkea131/jexactyl-installer"
GITHUB_UNINSTALL_URL="https://raw.githubusercontent.com/Nur4ik00p/Auto-Install-Thema-Pterodactyl/main"

LOG_PATH="/var/log/jexactyl-installer.log"

# exit with error status code if user is not root
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

output() {
  echo -e "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

execute() {
  echo -e "\n\n* jexactyl-installer $(date) \n\n" >>$LOG_PATH

  bash <(curl -s "$1") | tee -a $LOG_PATH
  [[ -n $2 ]] && execute "$2"
}

done=false

output "Jexactyl installation script @ $SCRIPT_VERSION"
output
output "Jexactyl Installer fork of Pterodactyl Installer"
output "https://github.com/linkea131/Jexactyl-installer"
output "https://github.com/vilhelmprytz/pterodactyl-installer"
output
output "Sponsoring/Donations: https://github.com/vilhelmprytz/pterodactyl-installer?sponsor=1"
output "This script is not associated with the official Pterodactyl Project and jexactyl"

output

PANEL_LATEST="$GITHUB_BASE_URL/$SCRIPT_VERSION/install-panel.sh"

WINGS_LATEST="$GITHUB_BASE_URL/$SCRIPT_VERSION/install-wings.sh"

PANEL_CANARY="$GITHUB_BASE_URL/master/install-panel.sh"

WINGS_CANARY="$GITHUB_BASE_URL/master/install-wings.sh"

UNINSTALL="$GITHUB_UNINSTALL_URL/uninstall.sh"

while [ "$done" == false ]; do
  options=(
    "Install the panel"
    "Install Wings"
    "Install both [0] and [1] on the same machine (wings script runs after panel)\n"

    "Install panel with canary version of the script (the versions that lives in master, may be broken!)"
    "Install Wings with canary version of the script (the versions that lives in master, may be broken!)"
    "Install both [3] and [4] on the same machine (wings script runs after panel)"
    "uninstall panel and wings"
  )

  actions=(
    "$PANEL_LATEST"
    "$WINGS_LATEST"
    "$PANEL_LATEST;$WINGS_LATEST"

    "$PANEL_CANARY"
    "$WINGS_CANARY"
    "$PANEL_CANARY;$WINGS_CANARY"
    "$UNINSTALL"
  )

  output "What would you like to do?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Input 0-$((${#actions[@]} - 1)): "
  read -r action

  [ -z "$action" ] && error "Input is required" && continue

  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && IFS=";" read -r i1 i2 <<<"${actions[$action]}" && execute "$i1" "$i2"
done
