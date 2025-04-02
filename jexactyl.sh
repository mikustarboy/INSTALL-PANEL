#!/bin/bash

output(){
    echo -e '\e[35m'$1'\e[0m';
}

warn(){
    echo -e '\e[31m'$1'\e[0m';
}

PANEL=latest
WINGS=latest

preflight(){
    output "Скрипт установки и обновления Jexactyl"
    output "Авторские права © 2022 Games-Cloud"
    output ""

    output "Обратите внимание, что этот скрипт предназначен для установки на новую ОС. Установка его на несвежую ОС может вызвать проблемы."
    output "Автоматическое определение операционной системы инициализировано..."

    os_check

    if [ "$EUID" -ne 0 ]; then
        output "Запустите, пожалуйста, как root."
        exit 3
    fi

    output "Автоматическое определение архитектуры инициализировано..."
    MACHINE_TYPE=`uname -m`
    if [ "${MACHINE_TYPE}" == 'x86_64' ]; then
        output "Обнаружен 64-битный сервер! Готово."
        output ""
    else
        output "Обнаружена неподдерживаемая архитектура! Переключитесь на 64-битную (x86_64)."
        exit 4
    fi

    output "Автоматическое обнаружение виртуализации инициализировано..."
    if [ "$lsb_dist" =  "ubuntu" ]; then
        apt-get update --fix-missing
        apt-get -y install software-properties-common
        add-apt-repository -y universe
        apt-get -y install virt-what curl
    elif [ "$lsb_dist" =  "debian" ]; then
        apt update --fix-missing
        apt-get -y install software-properties-common virt-what wget curl dnsutils
    elif [ "$lsb_dist" = "fedora" ] || [ "$lsb_dist" = "centos" ] || [ "$lsb_dist" = "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        yum -y install virt-what wget bind-utils
    fi
    virt_serv=$(echo $(virt-what))
    if [ "$virt_serv" = "" ]; then
        output "Virtualization: Bare Metal detected."
    elif [ "$virt_serv" = "openvz lxc" ]; then
        output "Виртуализация: обнаружен OpenVZ 7."
    elif [ "$virt_serv" = "xen xen-hvm" ]; then
        output "Виртуализация: обнаружен Xen-HVM."
    elif [ "$virt_serv" = "xen xen-hvm aws" ]; then
        output "Виртуализация: обнаружен Xen-HVM на AWS."
        warn "При создании выделений для этого узла используйте внутренний IP-адрес, поскольку Google Cloud использует маршрутизацию NAT."
        warn "Resuming in 10 seconds..."
        sleep 10
    else
        output "Виртуализация: обнаружен $virt_serv"
    fi
    output ""
    if [ "$virt_serv" != "" ] && [ "$virt_serv" != "kvm" ] && [ "$virt_serv" != "vmware" ] && [ "$virt_serv" != "hyperv" ] && [ "$virt_serv" != "openvz lxc" ] && [ "$virt_serv" != "xen xen-hvm" ] && [ "$virt_serv" != "xen xen-hvm aws" ]; then
        warn "Обнаружен неподдерживаемый тип виртуализации. Проконсультируйтесь с вашим хостинг-провайдером, может ли ваш сервер запустить Docker. Действуйте на свой страх и риск."
        warn "Если в будущем ваш сервер выйдет из строя, поддержка не предоставляется."
        warn "Продолжить?\n[1] Да.\n[2] Нет."
        read choice
        case $choice in 
            1)  output "Продолжается..."
                ;;
            2)  output "Отмена установки..."
                exit 5
                ;;
        esac
        output ""
    fi

    output "Инициализировано обнаружение ядра..."
    if echo $(uname -r) | grep -q xxxx; then
        output "Обнаружено ядро OVH. Этот скрипт не будет работать. Пожалуйста, переустановите сервер, используя универсальное/дистрибутивное ядро."
        output "Когда вы переустанавливаете сервер, нажмите «выборочная установка», а затем нажмите «использовать дистрибутивное» ядро."
        output "Вы также можете захотеть выполнить пользовательское разбиение на разделы, удалить раздел /home и предоставить / все оставшееся пространство."
        output "Пожалуйста, не стесняйтесь обращаться к нам, если вам нужна помощь по этой проблеме."
        exit 6
    elif echo $(uname -r) | grep -q pve; then
        output "Обнаружено ядро Proxmox LXE. Вы решили продолжить на последнем шаге, поэтому мы действуем на ваш страх и риск."
        output "Продолжаем рискованную операцию..."
    elif echo $(uname -r) | grep -q stab; then
        if echo $(uname -r) | grep -q 2.6; then 
            output "Обнаружен OpenVZ 6. Этот сервер определенно не будет работать с Docker, независимо от того, что скажет ваш провайдер. Выход, чтобы избежать дальнейших повреждений. "
            exit 6
        fi
    elif echo $(uname -r) | grep -q gcp; then
        output "Обнаружена облачная платформа Google. "
        warn "Убедитесь, что у вас настроен статический IP-адрес, иначе система не будет работать после перезагрузки. "
        warn "Также убедитесь, что брандмауэр GCP разрешает порты, необходимые для нормальной работы сервера. "
        warn "При создании выделений для этого узла используйте внутренний IP-адрес, поскольку Google Cloud использует маршрутизацию NAT. "
        warn "Продолжение через 10 секунд... "
        sleep 10
    else
        output "Не обнаружено ни одного плохого ядра. Двигаемся дальше... "
        output ""
    fi
}

os_check(){
    if [ -r /etc/os-release ]; then
        lsb_dist="$(. /etc/os-release && echo "$ID")"
        dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
        if [ "$lsb_dist" = "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
            dist_version="$(echo $dist_version | awk -F. '{print $1}')"
        fi
    else
        exit 1
    fi
    
    if [ "$lsb_dist" =  "ubuntu" ]; then
        if  [ "$dist_version" != "22.04" ]; then
            output "Неподдерживаемая версия Ubuntu. Поддерживается только Ubuntu 22.04. "
            exit 2
        fi
    elif [ "$lsb_dist" = "debian" ]; then
        if [ "$dist_version" != "11" ]; then
            output "Неподдерживаемая версия Debian. Поддерживается только Debian 10. "
            exit 2
        fi
    elif [ "$lsb_dist" = "fedora" ]; then
        if [ "$dist_version" != "35" ]; then
            output "Неподдерживаемая версия Fedora. Поддерживается только Fedora 34. "
            exit 2
        fi
    elif [ "$lsb_dist" = "centos" ]; then
        if [ "$dist_version" != "8" ]; then
            output "Неподдерживаемая версия CentOS. Поддерживается только CentOS Stream 8. "
            exit 2
        fi
    elif [ "$lsb_dist" = "rhel" ]; then
        if  [ $dist_version != "8" ]; then
            output "Неподдерживаемая версия RHEL. Поддерживается только RHEL 8. "
            exit 2
        fi
    elif [ "$lsb_dist" = "rocky" ]; then
        if [ "$dist_version" != "8" ]; then
            output "Неподдерживаемая версия Rocky Linux. Поддерживается только Rocky Linux 8. "
            exit 2
        fi
    elif [ "$lsb_dist" = "almalinux" ]; then
        if [ "$dist_version" != "8" ]; then
            output "Неподдерживаемая версия AlmaLinux. Поддерживается только AlmaLinux 8. "
            exit 2
        fi
    elif [ "$lsb_dist" != "ubuntu" ] && [ "$lsb_dist" != "debian" ] && [ "$lsb_dist" != "fedora" ] && [ "$lsb_dist" != "centos" ] && [ "$lsb_dist" != "rhel" ] && [ "$lsb_dist" != "rocky" ] && [ "$lsb_dist" != "almalinux" ]; then
        output "Неподдерживаемая операционная система. "
        output ""
        output "Supported OS:"
        output "Ubuntu: 20.04"
        output "Debian: 11"
        output "Fedora: 35"
        output "CentOS Stream: 8"
        output "Rocky Linux: 8"
	output "AlmaLinux: 8"
        output "RHEL: 8"
        exit 2
    fi
}

install_options(){
    output "Выберите вариант установки: "
    output "[1] Установите панель ${PANEL}. "
    output "[2] Установите панел без ssl с айпи ${PANEL}."
    output "[3] Установите wings ${WINGS}. "
    output "[4] Обновить панель до ${PANEL}."
    output "[5] Улучшите wings до ${WINGS}. "
    output "[6] Удаления файл и mysql"
    read -r choice
    case $choice in
        1 ) installoption=1
            output "Вы выбрали только установку панели ${PANEL}. "
            ;;
        2 ) installoption=2
            output "Вы выбрали только установку панели без ssl ${PANEL}. "
            ;;    
        3 ) installoption=3
            output "Вы выбрали только установку wings ${WINGS}. "
            ;;
        4 ) installoption=4
            output "Вы решили обновить панель до ${PANEL}. "
            ;;
	5 ) installoption=5
            output "Вы решили обновить демон до ${DAEMON}. "
            ;;
        6 ) installoption=6
            output "Вы выбрали удаления файл и mysql."
            ;;
        * ) output "Вы не ввели правильный выбор. "
            install_options
    esac
}

required_infos() {
    output "Введите желаемый адрес электронной почты пользователя: "
    read -r email
    dns_check
}

required_2_infos() {
    output "Введите желаемый адрес электронной почты пользователя: "
    read -r email
    dns_2_check
}

dns_2_check() {
    output "Введите ваше полное айпи (198.1.1.1): "
    read -r ADDRESS
}

dns_check(){
    output "Введите ваше полное доменное имя (panel.domain.tld): "
    read -r FQDN

    output "Разрешение DNS... "
    SERVER_IP=$(dig +short myip.opendns.com @resolver1.opendns.com -4)
    DOMAIN_RECORD=$(dig +short ${FQDN})
    if [ "${SERVER_IP}" != "${DOMAIN_RECORD}" ]; then
        output ""
        output "Введенный домен не соответствует основному публичному IP-адресу этого сервера. "
        output "Пожалуйста, сделайте запись A, указывающую на IP вашего сервера. Например, если вы сделаете запись A с именем 'panel', указывающую на IP вашего сервера, ваше полное доменное имя будет panel.domain.tld "
        output "Если вы используете Cloudflare, отключите оранжевое облако. "
        dns_check
    else
        output "Домен разрешен правильно. Хорошо, можно продолжать..."
    fi
}

repositories_setup(){
    output "Настройка репозиториев..."
    if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        apt -y install sudo
        apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg

        LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
        add-apt-repository ppa:redislabs/redis -y
        apt -y update
	    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
        if [ "$lsb_dist" =  "ubuntu" ]; then
            LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
	    apt -y install tuned dnsutils
            tuned-adm profile latency-performance
        elif [ "$lsb_dist" =  "debian" ]; then
            apt-get -y install ca-certificates apt-transport-https
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
            apt -y install dirmngr
            wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
            sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
            apt -y install tuned
            tuned-adm profile latency-performance
            apt-get -y update
            apt-get -y upgrade
            apt-get -y autoremove
            apt-get -y autoclean
            apt-get -y install curl
        fi
    elif  [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
    	dnf -y install dnf-utils
        if  [ "$lsb_dist" =  "fedora" ] ; then
            dnf -y install http://rpms.remirepo.net/fedora/remi-release-35.rpm
	else	
	    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
	    dnf -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm
	fi
#	dnf config-manager --set-enabled remi
#        dnf -y install tuned dnf-automatic
#        tuned-adm profile latency-performance
#	systemctl enable --now irqbalance
#	sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/dnf/automatic.conf
#	systemctl enable --now dnf-automatic.timer
#        dnf -y upgrade
#        dnf -y autoremove
#        dnf -y clean packages
#        dnf -y install curl bind-utils cronie
    fi
#    systemctl enable --now fstrim.timer
}

install_dependencies(){
    output "Установка зависимостей..."
    if  [ "$lsb_dist" =  "ubuntu" ] ||  [ "$lsb_dist" =  "debian" ]; then
        apt -y install php8.1 php8.1-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    else
    	dnf -y module install nginx:mainline/common
	dnf -y module install php:remi-8.1/common
	dnf -y module install redis:remi-6.2/common
	dnf -y module install mariadb:10.5/server
        dnf -y install git policycoreutils-python-utils unzip wget expect jq php-mysql php-zip php-bcmath tar composer
    fi

#    output "Enabling Services..."
#    if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
#        systemctl enable --now redis-server
#        systemctl enable --now php8.1-fpm
#    elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
#        systemctl enable --now redis
#        systemctl enable --now php-fpm
#    fi
#
#    systemctl enable --now cron
#    systemctl enable --now mariadb
#    systemctl enable --now nginx
}

install_jexactyl() {
    output "Создание баз данных и установка пароля root... "
    password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    Q1="CREATE USER 'jexactyl'@'127.0.0.1' IDENTIFIED BY '$password';"
    Q2="CREATE DATABASE IF NOT EXISTS panel;"
    Q3="GRANT ALL PRIVILEGES ON panel.* TO 'jexactyl'@'127.0.0.1' WITH GRANT OPTION;"
    Q4="exit;"
    
    SQL="${Q1}${Q2}${Q3}${Q4}"
    mysql -e "$SQL"

    output "Загрузка Jexactyl... "
    mkdir -p /var/www/jexactyl
    cd /var/www/jexactyl || exit
    if [ ${PANEL} = "latest" ]; then
    	curl -Lo panel.tar.gz https://github.com/jexactyl/jexactyl/releases/latest/download/panel.tar.gz
    else
    	curl -Lo panel.tar.gz https://github.com/jexactyl/jexactyl/releases/download/${PANEL}/panel.tar.gz
    fi
    tar -xzvf panel.tar.gz
    chmod -R 755 storage/* bootstrap/cache/

    output "Установка Jexactyl..."
 
    cp .env.example .env
    # Fixed in latest release
    # sed -i 's/APP_KEY=/APP_KEY=base64:voLfFx5NqSPFiuo1lv077qKsT9oKhIPFDLNl4x0PGqk=/' .env
    php artisan key:generate --force << EOF
yes
yes
EOF
    
    composer install --no-dev --optimize-autoloader --no-interaction
    
    php artisan p:environment:setup -n --author=$email --url=https://$FQDN --timezone=America/New_York --cache=redis --session=database --queue=redis --redis-host=127.0.0.1 --redis-pass= --redis-port=6379
    php artisan p:environment:database --host=127.0.0.1 --port=3306 --database=panel --username=jexactyl --password=$password
    
    php artisan migrate --seed --force
    php artisan p:user:make --email=$email --admin=1
    if  [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        chown -R www-data:www-data * /var/www/jexactyl
    elif  [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        chown -R nginx:nginx * /var/www/jexactyl
	semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/jexactyl/storage(/.*)?"
        restorecon -R /var/www/jexactyl
    fi

    output "Создание слушателей очереди панелей..."
    (crontab -l ; echo "* * * * * php /var/www/jexactyl/artisan schedule:run >> /dev/null 2>&1")| crontab -

    if  [ "$lsb_dist" =  "ubuntu" ] ||  [ "$lsb_dist" =  "debian" ]; then
        cat > /etc/systemd/system/pteroq.service <<- 'EOF'
# Jexactyl Queue Worker File
# ----------------------------------

[Unit]
Description=Jexactyl Queue Worker
After=redis-server.service

[Service]
# On some systems the user and group might be different.
# Some systems use `apache` or `nginx` as the user and group.
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/jexactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
    elif  [ "$lsb_dist" =  "fedora" ] ||  [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        cat > /etc/systemd/system/pteroq.service <<- 'EOF'
# Jexactyl Queue Worker File
# ----------------------------------

[Unit]
Description=Jexactyl Queue Worker
After=redis-server.service

[Service]
# On some systems the user and group might be different.
# Some systems use `apache` or `nginx` as the user and group.
User=nginx
Group=nginx
Restart=always
ExecStart=/usr/bin/php /var/www/jexactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
        setsebool -P httpd_can_network_connect 1
	setsebool -P httpd_execmem 1
	setsebool -P httpd_unified 1
    fi
    sudo systemctl daemon-reload
    systemctl enable --now pteroq.service
}

install_2_jexactyl() {
    output "Создание баз данных и установка пароля root... "
    password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    Q1="CREATE USER 'jexactyl'@'127.0.0.1' IDENTIFIED BY '$password';"
    Q2="CREATE DATABASE IF NOT EXISTS panel;"
    Q3="GRANT ALL PRIVILEGES ON panel.* TO 'jexactyl'@'127.0.0.1' WITH GRANT OPTION;"
    Q4="exit;"
    
    SQL="${Q1}${Q2}${Q3}${Q4}"
    mysql -e "$SQL"

    output "Загрузка Jexactyl... "
    mkdir -p /var/www/jexactyl
    cd /var/www/jexactyl || exit
    if [ ${PANEL} = "latest" ]; then
    	curl -Lo panel.tar.gz https://github.com/jexactyl/jexactyl/releases/latest/download/panel.tar.gz
    else
    	curl -Lo panel.tar.gz https://github.com/jexactyl/jexactyl/releases/download/${PANEL}/panel.tar.gz
    fi
    tar -xzvf panel.tar.gz
    chmod -R 755 storage/* bootstrap/cache/

    output "Установка Jexactyl..."
 
    cp .env.example .env
    # Fixed in latest release
    # sed -i 's/APP_KEY=/APP_KEY=base64:voLfFx5NqSPFiuo1lv077qKsT9oKhIPFDLNl4x0PGqk=/' .env
    php artisan key:generate --force << EOF
yes
yes
EOF
    
    composer install --no-dev --optimize-autoloader --no-interaction
    
    php artisan p:environment:setup -n --author=$email --url=http://$ADDRESS --timezone=America/New_York --cache=redis --session=database --queue=redis --redis-host=127.0.0.1 --redis-pass= --redis-port=6379
    php artisan p:environment:database --host=127.0.0.1 --port=3306 --database=panel --username=jexactyl --password=$password
    
    php artisan migrate --seed --force
    php artisan p:user:make --email=$email --admin=1
    if  [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        chown -R www-data:www-data * /var/www/jexactyl
    elif  [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        chown -R nginx:nginx * /var/www/jexactyl
	semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/jexactyl/storage(/.*)?"
        restorecon -R /var/www/jexactyl
    fi

    output "Создание слушателей очереди панелей..."
    (crontab -l ; echo "* * * * * php /var/www/jexactyl/artisan schedule:run >> /dev/null 2>&1")| crontab -

    if  [ "$lsb_dist" =  "ubuntu" ] ||  [ "$lsb_dist" =  "debian" ]; then
        cat > /etc/systemd/system/pteroq.service <<- 'EOF'
# Jexactyl Queue Worker File
# ----------------------------------

[Unit]
Description=Jexactyl Queue Worker
After=redis-server.service

[Service]
# On some systems the user and group might be different.
# Some systems use `apache` or `nginx` as the user and group.
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/jexactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
    elif  [ "$lsb_dist" =  "fedora" ] ||  [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        cat > /etc/systemd/system/pteroq.service <<- 'EOF'
# Jexactyl Queue Worker File
# ----------------------------------

[Unit]
Description=Jexactyl Queue Worker
After=redis-server.service

[Service]
# On some systems the user and group might be different.
# Some systems use `apache` or `nginx` as the user and group.
User=nginx
Group=nginx
Restart=always
ExecStart=/usr/bin/php /var/www/jexactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
        setsebool -P httpd_can_network_connect 1
	setsebool -P httpd_execmem 1
	setsebool -P httpd_unified 1
    fi
    sudo systemctl daemon-reload
    systemctl enable --now pteroq.service
}

upgrade_jexactyl(){
    cd /var/www/jexactyl && php artisan p:upgrade
    if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        chown -R www-data:www-data * /var/www/jexactyl
    elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" = "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        chown -R nginx:nginx * /var/www/jexactyl
        restorecon -R /var/www/jexactyl
    fi
    output "Ваша панель успешно обновлена до версии ${PANEL} "
}

nginx_config() {
    output "Отключение конфигурации по умолчанию... "
    rm -rf /etc/nginx/sites-enabled/default
    output "Настройка веб-сервера Nginx... "

echo '
server {
    listen 80;
    server_name '"$FQDN"';
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name '"$FQDN"';

    root /var/www/jexactyl/public;
    index index.php;

    access_log /var/log/nginx/jexactyl.app-access.log;
    error_log  /var/log/nginx/jexactyl.app-error.log error;

    # allow larger file uploads and longer script runtimes
    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/'"$FQDN"'/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/'"$FQDN"'/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
    ssl_prefer_server_ciphers on;

    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";
    add_header X-Frame-Options DENY;
    add_header Referrer-Policy same-origin;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        include /etc/nginx/fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
' | sudo -E tee /etc/nginx/sites-available/jexactyl.conf >/dev/null 2>&1
    ln -s /etc/nginx/sites-available/jexactyl.conf /etc/nginx/sites-enabled/jexactyl.conf
    service nginx restart
}

nginx_2_config() {
    output "Отключение конфигурации по умолчанию... "
    rm -rf /etc/nginx/sites-enabled/default
    output "Настройка веб-сервера Nginx... "

echo '
server {
    listen 80;
    server_name $ADDRESS;

    root /var/www/jexactyl/public;
    index index.html index.htm index.php;
    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/jexactyl.app-error.log error;

    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    location ~ .php$ {
        fastcgi_split_path_info ^(.+.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M 
 post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /.ht {
        deny all;
    }
}
' | sudo -E tee /etc/nginx/sites-available/jexactyl.conf >/dev/null 2>&1
    ln -s /etc/nginx/sites-available/jexactyl.conf /etc/nginx/sites-enabled/jexactyl.conf
    service nginx restart
}

nginx_config_redhat(){
    output "Configuring Nginx web server..."

echo '
server {
    listen 80;
    server_name '"$FQDN"';
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name '"$FQDN"';

    root /var/www/jexactyl/public;
    index index.php;

    access_log /var/log/nginx/jexactyl.app-access.log;
    error_log  /var/log/nginx/jexactyl.app-error.log error;

    # allow larger file uploads and longer script runtimes
    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/'"$FQDN"'/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/'"$FQDN"'/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
    ssl_prefer_server_ciphers on;

    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";
    add_header X-Frame-Options DENY;
    add_header Referrer-Policy same-origin;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        include /etc/nginx/fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
' | sudo -E tee /etc/nginx/conf.d/jexactyl.conf >/dev/null 2>&1

    service nginx restart
    chown -R nginx:nginx $(pwd)
    restorecon -R /var/www/jexactyl
}

nginx_2_config_redhat(){
    output "Configuring Nginx web server..."

echo '
server {
    listen 80;
    server_name $ADDRESS;

    root /var/www/jexactyl/public;
    index index.html index.htm index.php;
    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/jexactyl.app-error.log error;

    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    location ~ .php$ {
        fastcgi_split_path_info ^(.+.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M 
 post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /.ht {
        deny all;
    }
}
' | sudo -E tee /etc/nginx/conf.d/jexactyl.conf >/dev/null 2>&1

    service nginx restart
    chown -R nginx:nginx $(pwd)
    restorecon -R /var/www/jexactyl
}

php_config(){
    output "Настройка PHP-сокета..."
    bash -c 'cat > /etc/php-fpm.d/www-jexactyl.conf' <<-'EOF'
[jexactyl]

user = nginx
group = nginx

listen = /var/run/php-fpm/jexactyl.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0750

pm = ondemand
pm.max_children = 9
pm.process_idle_timeout = 10s
pm.max_requests = 200
EOF
    systemctl restart php-fpm
}

webserver_config(){
    if [ "$lsb_dist" =  "debian" ] || [ "$lsb_dist" =  "ubuntu" ]; then
        nginx_config
    elif  [ "$lsb_dist" =  "fedora" ] ||  [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        php_config
        nginx_config_redhat
	chown -R nginx:nginx /var/lib/php/session
    fi
}

webserver_2_config(){
    if [ "$lsb_dist" =  "debian" ] || [ "$lsb_dist" =  "ubuntu" ]; then
        nginx_2_config
    elif  [ "$lsb_dist" =  "fedora" ] ||  [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        php_config
        nginx_2_config_redhat
	chown -R nginx:nginx /var/lib/php/session
    fi
}

setup_jexactyl(){
    install_dependencies
    install_jexactyl
    ssl_certs
    webserver_config
}
setup_2_jexactyl(){
    install_dependencies
    install_2_jexactyl
    webserver_2_config
}


install_wings() {
    cd /root || exit
    output "Установка зависимостей Jexactyl Wings..."
    if  [ "$lsb_dist" =  "ubuntu" ] ||  [ "$lsb_dist" =  "debian" ]; then
        apt-get -y install curl tar unzip
    elif  [ "$lsb_dist" =  "fedora" ] ||  [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        dnf -y install curl tar unzip
    fi

    output "Installing Docker"
    if  [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        dnf -y install docker-ce --allowerasing
    else
        curl -sSL https://get.docker.com/ | CHANNEL=stable bash
    fi
    
    systemctl enable --now docker
    output "Установка wings Jexactyl... "
    mkdir -p /etc/jexactyl
    cd /etc/jexactyl || exit
    if [ ${WINGS} = "latest" ]; then
    	curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
    else
    	curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/download/${WINGS}/wings_linux_amd64
    fi
    chmod u+x /usr/local/bin/wings
    
      bash -c 'cat > /etc/systemd/system/wings.service' <<-'EOF'
[Unit]
Description=Jexactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/jexactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

    systemctl enable wings
    output "Wings ${WINGS} теперь установлен в вашей системе. "
    output "Вам следует перейти на панель и настроить узел прямо сейчас."
    output "Выполните команду `systemctl start wings` после запуска команды автоматического развертывания. "
    if  [ "$lsb_dist" != "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
    	output "------------------------------------------------------------------"
	output "ВАЖНОЕ ЗАМЕЧАНИЕ!!! "
	output "Поскольку вы работаете в системе с целевыми политиками SELinux, вам следует изменить каталог файлов сервера демонов с /var/lib/jexactyl/volumes на /var/srv/containers/jexactyl. "
	output "------------------------------------------------------------------"
    fi
}


upgrade_wings(){
    if [ ${WINGS} = "latest" ]; then
    	curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
    else
    	curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/download/${WINGS}/wings_linux_amd64
    fi
    chmod u+x /usr/local/bin/wings
    systemctl restart wings
    output "Ваши Wings обновлены до версии ${WINGS}."
}

ssl_certs(){
    output "Installing Let's Encrypt and creating an SSL certificate..."
    cd /root || exit
    if  [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        apt-get -y install certbot
    elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        dnf -y install certbot
    fi
    
    if [ "$installoption" = "1" ] || [ "$installoption" = "3" ]; then
        if  [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
            apt-get -y install python3-certbot-nginx
    	elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
            dnf -y install python3-certbot-nginx
    	fi
	certbot --nginx --redirect --no-eff-email --email "$email" --agree-tos -d "$FQDN"
	setfacl -Rdm u:mysql:rx /etc/letsencrypt
	setfacl -Rm u:mysql:rx /etc/letsencrypt
	systemctl restart mariadb
    fi
    
    if [ "$installoption" = "2" ]; then
	certbot certonly --standalone --no-eff-email --email "$email" --agree-tos -d "$FQDN" --non-interactive
    fi
    systemctl enable --now certbot.timer
}

firewall(){
    output "Setting up Fail2Ban..."
    if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        apt -y install fail2ban
    elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        dnf -y install fail2ban
    fi 
    systemctl enable fail2ban
    bash -c 'cat > /etc/fail2ban/jail.local' <<-'EOF'
[DEFAULT]
# Ban hosts for ten hours:
bantime = 36000
# Override /etc/fail2ban/jail.d/00-firewalld.conf:
banaction = iptables-multiport
[sshd]
enabled = true

EOF
    service fail2ban restart

    output "Настройка firewall..."
    if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        apt-get -y install ufw
        ufw allow 22
        if [ "$installoption" = "1" ]; then
            ufw allow 80
            ufw allow 443
            ufw allow 3306
        elif [ "$installoption" = "2" ]; then
            ufw allow 80
            ufw allow 8080
            ufw allow 2022
        elif [ "$installoption" = "3" ]; then
            ufw allow 80
            ufw allow 443
            ufw allow 8080
            ufw allow 2022
            ufw allow 3306
        fi
        yes | ufw enable 
    elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        dnf -y install firewalld
        systemctl enable firewalld
        systemctl start firewalld
        if [ "$installoption" = "1" ]; then
            firewall-cmd --add-service=http --permanent
            firewall-cmd --add-service=https --permanent 
            firewall-cmd --add-service=mysql --permanent
        elif [ "$installoption" = "2" ]; then
            firewall-cmd --permanent --add-service=80/tcp
            firewall-cmd --permanent --add-port=2022/tcp
            firewall-cmd --permanent --add-port=8080/tcp
	    firewall-cmd --permanent --zone=trusted --change-interface=jexactyl0
	    firewall-cmd --zone=trusted --add-masquerade --permanent
        elif [ "$installoption" = "3" ]; then
            firewall-cmd --add-service=http --permanent
            firewall-cmd --add-service=https --permanent 
            firewall-cmd --permanent --add-port=2022/tcp
            firewall-cmd --permanent --add-port=8080/tcp
            firewall-cmd --permanent --add-service=mysql
	    firewall-cmd --permanent --zone=trusted --change-interface=jexactyl0
	    firewall-cmd --zone=trusted --add-masquerade --permanent
        fi
    fi
}

harden_linux(){
    curl https://raw.githubusercontent.com/Whonix/security-misc/master/etc/modprobe.d/30_security-misc.conf >> /etc/modprobe.d/30_security-misc.conf
    curl https://raw.githubusercontent.com/Whonix/security-misc/master/etc/sysctl.d/30_security-misc.conf >> /etc/sysctl.d/30_security-misc.conf
    sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /etc/sysctl.d/30_security-misc.conf
    curl https://raw.githubusercontent.com/Whonix/security-misc/master/etc/sysctl.d/30_silent-kernel-printk.conf >> /etc/sysctl.d/30_silent-kernel-printk.conf
}

delete_mysql_data() {
    Q1="DROP DATABASE panel;"
    Q2="DROP USER 'jexactyl'@'127.0.0.1';"
    Q3="FLUSH PRIVILEGES;"
    Q4="exit;"
    
    SQL="${Q1}${Q2}${Q3}${Q4}"
    mysql -e "$SQL"
    output "Очистка базы данных panel..."
    output "База данных успешно очищена."
}

delete_jexactyl_files() {
    local panel_path="/var/www/jexactyl"
    if [ -d "$panel_path" ]; then
        rm -rf "$panel_path"
        output "Файлы панели Jexactyl удалены из $panel_path."
    else
        warn "Директория $panel_path не найдена. Файлы панели уже удалены или не были установлены."
    fi

    local nginx_config_path="/etc/nginx/sites-available/jexactyl.conf"
    local nginx_config_symlink="/etc/nginx/sites-enabled/jexactyl.conf"
    local nginx_config_rhel="/etc/nginx/conf.d/jexactyl.conf"

    if [ -f "$nginx_config_path" ]; then
        rm -f "$nginx_config_path"
        output "Файл конфигурации Nginx удален: $nginx_config_path."
    fi

    if [ -f "$nginx_config_symlink" ]; then
        rm -f "$nginx_config_symlink"
        output "Символическая ссылка Nginx удалена: $nginx_config_symlink."
    fi

    if [ -f "$nginx_config_rhel" ]; then
        rm -f "$nginx_config_rhel"
        output "Файл конфигурации Nginx для Red Hat-based систем удален: $nginx_config_rhel."
    fi

    output "Перезапуск Nginx..."
    systemctl restart nginx && output "Nginx успешно перезапущен." || warn "Ошибка при перезапуске Nginx."
}

broadcast(){
    output "------------------------------------------------------------------"
    output "Jexactyl успешно установлен! "
    output ""
    output "Примечание: все ненужные порты по умолчанию заблокированы."
    if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
        output "Use 'ufw allow <port>' to enable your desired ports."
    elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "rocky" ] || [ "$lsb_dist" = "almalinux" ]; then
        output "Use 'firewall-cmd --permanent --add-port=<port>/tcp' to enable your desired ports."
    fi
    output "------------------------------------------------------------------"
    output ""
}

broadcast_wings(){
    output "------------------------------------------------------------------"
    output "Wings успешно установлены!"
    output "------------------------------------------------------------------"
    output ""
}

#Execution
preflight
install_options
case $installoption in 
    1)  repositories_setup
        required_infos
        firewall
	harden_linux
        setup_jexactyl
        broadcast
	install_options
        ;;
    2)  repositories_setup
        required_2_infos
        firewall
	harden_linux
        setup_2_jexactyl
        broadcast
	install_options
        ;;    
    3)  repositories_setup
        firewall
	harden_linux
        install_wings
        broadcast_wings
	install_options
        ;;
    4)  upgrade_jexactyl
        install_options
        ;;
    5)  upgrade_wings
        install_options
        ;;
    6)  delete_mysql_data
        delete_jexactyl_files
	install_options
        ;;
esac
