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
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 4
  clear
}

#Update and install jq
install_jq() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo apt update && sudo apt install -y jq
  if [ $? -eq 0 ]; then
    echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  else
    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+]              УСТАНОВИТЬ НЕ УДАЛОСЬ                   [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    exit 1
  fi
  echo -e "                                                       "
  sleep 1
  clear
}
#Check user token
check_token() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "${GREEN} MASUKKAN PASSWORD"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "MIKU" ]; then
    echo -e "${GREEN} PASSWORD BENAR ✅${NC}}"
  else
    echo -e "${RED} PASSWORD SALAH TOD ❌${NC}"
    echo -e "${YELLOW}TELEGRAM : @Mikudev${NC}"
    echo -e "${YELLOW}©MIKU DEV${NC}"
    exit 1
  fi
  clear
}

# Install theme
install_theme() {
  while true; do
    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
    echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
    echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
    echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "                                                       "
    echo -e "ВЫБЕРИТЕ ТЕМУ, КОТОРУЮ ХОТИТЕ УСТАНОВИТЬ"
    echo " 1. STELLAR"
    echo " 2.BILLING"
    echo " 3. ENIGMA"
    echo " x. KEMBALI KEMENU"
    echo -e " PILIH MENU"
    read -r SELECT_THEME
    case "$SELECT_THEME" in
      1)
        THEME_URL=$(echo -e "https://github.com/mikustarboy/INSTALL-PANEL/raw/main/stellar.zip")        
        break
        ;;
      2)
        THEME_URL=$(echo -e "https://github.com/mikustarboy/INSTALL-PANEL/raw/main/billing.zip")
        break
        ;;
      3)
        THEME_URL=$(echo -e "https://github.com/mikustarboy/INSTALL-PANEL/raw/main/enigma.zip")
        break
        ;; 
      x)
        return
        ;;
      *)
        echo -e "${GREEN}Неверный выбор, попробуйте еще раз.${NC}"
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
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
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
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 2
  clear
  exit 0

elif [ "$SELECT_THEME" -eq 2 ]; then
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
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
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  return

elif [ "$SELECT_THEME" -eq 3 ]; then
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
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
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 5
else
  echo ""
  echo "Неверный выбор. пожалуйста, выберите 1/2/3."
fi
}


# Uninstall theme
uninstall_theme() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  bash <(curl https://raw.githubusercontent.com/mikustarboy/INSTALL-PANEL/main/repair.sh)
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
}
install_themeSteeler() {
#!/bin/bash

echo -e "                                                       "
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e "${GREEN}[+]                  УСТАНОВКА ТЕМЫ               [+]${NC}"
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e "                                                                   "

# Unduh file tema
wget -O /root/stellar.zip https://github.com/mikustarboy/INSTALL-PANEL/raw/main/stellar.zip


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
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e ""
sleep 2
clear
exit 0

}
create_node() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  #!/bin/bash
#!/bin/bash

# Minta input dari pengguna
read -p "Введите название локации: " location_name
read -p "Введите описание местоположения: " location_description
read -p "Введите домен: " domain
read -p "Введите имя узла: " node_name
read -p "Введите ОЗУ (в МБ): " ram
read -p "Введите максимальный объем дискового пространства (в МБ): " disk_space
read -p "Введите Локация айди: " locid

# Ubah ke direktori pterodactyl
cd /var/www/pterodactyl || { echo "Каталог не найден"; exit 1; }

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
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
uninstall_panel() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "


bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
EOF


  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
configure_wings() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  #!/bin/bash

# Minta input token dari pengguna
read -p "Введите Настроить токен запуска wings: " wings

eval "$wings"
# Menjalankan perintah systemctl start wings
sudo systemctl start wings

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}
hackback_panel() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
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
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  
  exit 0
}
ubahpw_vps() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
read -p "Введите новый пароль: " pw
read -p "Повторно введите новый пароль: " pw

passwd <<EOF
$pw
$pw

EOF


  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AUTHOR     : MIKUDEV ${NC}"
  echo -e "${GREEN}[+] WhattsApp : 6285823103767 ${NC}"
  echo -e "${GREEN}[+] Telegram  : @Mikudev ${NC}"
  echo -e "${GREEN}[+] Script    : AUTO INSTALL PANEL DAN THEMA ${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
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
  echo -e " BOT INSTALL PANEL & THEMA"
  echo " 1. INSTALL THEMA"
  echo " 2. HAPUS THEMA"
  echo " 3. INSTALL WINGS"
  echo " 4. BUAT NODE"
  echo " 5. HAPUS INSTALLER PANEL"
  echo " 6. THEMA STELLAR V2"
  echo " 7. BUAT AKUN PANEL"
  echo " 8. UBAH KATA SANDI VPS"
  echo " x. Exit"
  echo -e " PILIH MENU"
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
