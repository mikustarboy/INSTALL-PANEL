#!/bin/bash

# Color
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 4
  clear
}

#Update and install jq
install_jq() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo apt update && sudo apt install -y jq
  if [ $? -eq 0 ]; then
    echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  else
    echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
    exit 1
  fi
  echo -e "                                                       "
  sleep 1
  clear
}
#Check user token
check_token() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "${YELLOW} MASUKAN TOKEN DARI AUTHOR :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "MIKU DEV" ]; then
    echo -e "${GREEN} TOKEN DIKONFIRMASI${NC}}"
  else
    echo -e "${GREEN} TOKEN SALAH COK. MINTA SAMA AUTHOR SANA${NC}"
    echo -e "${YELLOW} TELEGRAM : @Mikudev${NC}"
    echo -e "${YELLOW}©MIKU${NC}"
    exit 1
  fi
  clear
}

# Install theme
install_theme() {
  while true; do
    echo -e "                                                       "
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
    echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
    echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
    echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
    echo -e "${RED}[+] =============================================== [+]${NC}"
    echo -e "                                                       "
    echo -e " PILIH TEMA YANG KAMU SUKA"
    echo " 1. stellar"
    echo " 2. billing"
    echo " 3. enigma"
    echo " x. Exit"
    echo -e " PILIH MENU:"
    read -r SELECT_THEME
    case "$SELECT_THEME" in
      1)
        THEME_URL=$(echo -e "https://github.com/Nur4ik00p/Auto-Install-Thema-Pterodactyl/raw/main/stellar.zip")        
        break
        ;;
      2)
        THEME_URL=$(echo -e "https://github.com/Nur4ik00p/Auto-Install-Thema-Pterodactyl/raw/main/billing.zip")
        break
        ;;
      3)
        THEME_URL=$(echo -e "https://github.com/Nur4ik00p/Auto-Install-Thema-Pterodactyl/raw/main/enigma.zip")
        break
        ;; 
      x)
        return
        ;;
      *)
        echo -e "${RED}Неверный выбор, попробуйте еще раз.${NC}"
        ;;
    esac
  done
  
if [ -e /root/pterodactyl ]; then
    sudo rm -rf /root/pterodactyl
  fi
  wget -q "$THEME_URL"
  sudo unzip -o "$(basename "$THEME_URL")"
  
if [ "$SELECT_THEME" -eq 1 ]; then
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                                   "
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan migrate
  yarn build:production
  php artisan view:clear
  sudo rm /root/stellar.zip
  sudo rm -rf /root/pterodactyl

  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 2
  clear
  exit 0

elif [ "$SELECT_THEME" -eq 2 ]; then
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan billing:install stable
  php artisan migrate
  yarn build:production
  php artisan view:clear
  sudo rm /root/billing.zip
  sudo rm -rf /root/pterodactyl

  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  return

elif [ "$SELECT_THEME" -eq 3 ]; then
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                                   "    
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan migrate
  yarn build:production
  php artisan view:clear
  sudo rm /root/enigma.zip
  sudo rm -rf /root/pterodactyl

  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 5
else
  echo ""
  echo " PILIH YANG BENAR GOBLOK."
fi
}


# Uninstall theme
uninstall_theme() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  bash <(curl https://raw.githubusercontent.com/Nur4ik00p/Auto-Install-Thema-Pterodactyl/main/repair.sh)
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
}
install_themeSteeler() {
#!/bin/bash

echo -e "                                                       "
echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
echo -e "                                                                   "

# Unduh file tema
wget -O /root/stellar.zip https://github.com/Nur4ik00p/Auto-Install-Thema-Pterodactyl/raw/main/stellar.zip


# Ekstrak file tema
unzip /root/stellar.zip -d /root/pterodactyl

# Salin tema ke direktori Pterodactyl
sudo cp -rfT /root/pterodactyl /var/www/pterodactyl

# Instal Node.js dan Yarn
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm i -g yarn

# Instal dependensi dan build tema
cd /var/www/pterodactyl
yarn add react-feather
php artisan migrate
yarn build:production
php artisan view:clear

# Hapus file dan direktori sementara
sudo rm /root/stellar.zip
sudo rm -rf /root/pterodactyl

echo -e "                                                       "
echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
echo -e ""
sleep 2
clear
exit 0

}
create_node() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  #!/bin/bash
#!/bin/bash

# Minta input dari pengguna
read -p " MASUKAN NAMA LOKASI :" location_name
read -p " MASUKAN DESCRIPSI NYA : " location_description
read -p " MASUKAN DOMAIN : " domain
read -p " MASUKAN NAMA NODE" node_name
read -p " MASUKAN RAM DALAM (MB)" ram
read -p " MASUKAN DISK SPACE" disk_space
read -p " MASUKAN ID LOKASI" locid

# Ubah ke direktori pterodactyl
cd /var/www/pterodactyl || { echo " PENYIMPANAN TIDAK DI TEMUKAN"; exit 1; }

# Membuat lokasi baru
php artisan p:location:make <<EOF
$location_name
$location_description
EOF

# Membuat node baru
php artisan p:node:make <<EOF
$node_name
$location_description
$locid
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
uninstall_panel() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "


bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
EOF


  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
configure_wings() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  #!/bin/bash

# Minta input token dari pengguna
read -p "Введите Настроить токен запуска wings: " wings

eval "$wings"
# Menjalankan perintah systemctl start wings
sudo systemctl start wings

  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
hackback_panel() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  # Minta input dari pengguna
read -p "Войдите в панель имени пользователя: " user
read -p "пароль для входа: " psswdhb
  #!/bin/bash
cd /var/www/pterodactyl || { echo "Каталог не найден"; exit 1; }

# Membuat lokasi baru
php artisan p:user:make <<EOF
yes
hackback@gmail.com
$user
$user
$user
$psswdhb
EOF
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  
  exit 0
}
ubahpw_vps() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
read -p "Введите новый пароль: " pw
read -p "Повторно введите новый пароль: " pw

passwd <<EOF
$pw
$pw

EOF


  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${BLUE}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${BLUE}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${BLUE}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  
  exit 0
}
# Main script
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e "MENU MIKU DEV"
  echo " 1. Install Thema"
  echo " 2. Hapus Tema"
  echo " 3. Install wings"
  echo " 4. Сreate Node"
  echo " 5. Hapus Panel"
  echo " 6. Install Thema Stelar New By Miku"
  echo " 7. HackBack Panel"
  echo " 8. Ubah Pw Vps"
  echo " x. Exit"
  echo -e " PILIH MENU :"
  read -r MENU_CHOICE
  clear

  case "$MENU_CHOICE" in
    1)
      install_theme
      ;;
    2)
      uninstall_theme
      ;;
      3)
      configure_wings
      ;;
      4)
      create_node
      ;;
      5)
      uninstall_panel
      ;;
      6)
      install_themeSteeler
      ;;
      7)
      hackback_panel
      ;;
      8)
      ubahpw_vps
      ;;
    x)
      echo "Откажитесь от сценария."
      exit 0
      ;;
    *)
      echo "Неверный выбор, попробуйте еще раз."
      ;;
  esac
done