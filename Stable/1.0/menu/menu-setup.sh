#!/bin/bash
# (C) Copyright 2021-2022 By joysmark
# ==================================================================
# Name        : VPN Script Quick Installation Script
# Description : This Script Is Setup for running other
#               quick Setup script from one click installation
# Created     : 16-05-2022 ( 16 May 2022 )
# OS Support  : Ubuntu & Debian
# Auther      : joysmark
# WebSite     : https://t.me/joysmark
# Github      : github.com/Mjoyvpn
# ==================================================================

# // Export Color & Information
export RED='\033[0;31m';
export GREEN='\033[0;32m';
export YELLOW='\033[0;33m';
export BLUE='\033[0;34m';
export PURPLE='\033[0;35m';
export CYAN='\033[0;36m';
export LIGHT='\033[0;37m';
export NC='\033[0m';

# // Export Banner Status Information
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export RED_BG='\e[41m';

# // Export Align
export BOLD="\e[1m";
export WARNING="${RED}\e[5m";
export UNDERLINE="\e[4m";

# // Export OS Information
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

# // String For Helping Installation
export VERSION="1.0";
export EDITION="Stable";
export AUTHER="joysmark";
export ROOT_DIRECTORY="/etc/joysmark";
export CORE_DIRECTORY="/usr/local/joysmark";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script";
export REPO_URL="https://repository.joysmark.me";

# // Checking Your Running Or Root or no
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Please run this script as root user";
		exit 1;
fi

# // Checking Requirement Installed / No
if ! which jq > /dev/null; then
    rm -f /root/menu-setup.sh;
    rm -f /root/requirement.sh;
    rm -f /root/nginx.sh;
    rm -f /root/setup.sh;
    clear
    echo -e "${ERROR} JQ Packages Not installed";
    exit 1;
fi

# // Exporting Network Information
wget -qO- --inet4-only 'https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/get-ip_sh' | bash;
source /root/ip-detail.txt;
export IP_NYA="$IP";
export ASN_NYA="$ASN";
export ISP_NYA="$ISP";
export REGION_NYA="$REGION";
export CITY_NYA="$CITY";
export COUNTRY_NYA="$COUNTRY";
export TIME_NYA="$TIMEZONE";

# // Clear
clear
# // Downloading Menu
export Layanan='trojan';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='vmess';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='vless';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='ss';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='ssh';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='wg';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='socks';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='http';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='ssr';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

# // Panel Tools
wget -q -O /usr/local/sbin/panel-add-http "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-http.sh"; chmod +x /usr/local/sbin/panel-add-http;
wget -q -O /usr/local/sbin/panel-add-ssh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-ssh.sh"; chmod +x /usr/local/sbin/panel-add-ssh;
wget -q -O /usr/local/sbin/panel-add-wg "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-wg.sh"; chmod +x /usr/local/sbin/panel-add-wg;
wget -q -O /usr/local/sbin/panel-add-trojan "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-trojan.sh"; chmod +x /usr/local/sbin/panel-add-trojan;
wget -q -O /usr/local/sbin/panel-add-vmess "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-vmess.sh"; chmod +x /usr/local/sbin/panel-add-vmess;
wget -q -O /usr/local/sbin/panel-add-vless "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-vless.sh"; chmod +x /usr/local/sbin/panel-add-vless;
wget -q -O /usr/local/sbin/panel-add-socks "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-socks.sh"; chmod +x /usr/local/sbin/panel-add-socks;
wget -q -O /usr/local/sbin/panel-add-ss "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/panel/panel-add-ss.sh"; chmod +x /usr/local/sbin/panel-add-ss;

# // Other
wget -q -O /usr/local/sbin/menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/menu.sh"; chmod +x /usr/local/sbin/menu;
wget -q -O /usr/local/sbin/lcn-change "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/other/change-lcn.sh"; chmod +x /usr/local/sbin/lcn-change;
wget -q -O /usr/local/sbin/speedtest "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Core/speedtest"; chmod +x /usr/local/sbin/speedtest;
wget -q -O /usr/local/sbin/ram-usage "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Core/ram-usage.sh"; chmod +x /usr/local/sbin/ram-usage;
wget -q -O /usr/local/sbin/autokill-menu "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/pro/autokill/menu.sh"; chmod +x /usr/local/sbin/autokill-menu;
wget -q -O /usr/local/sbin/autoexp "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/autoexp.sh"; chmod +x /usr/local/sbin/autoexp;
wget -q -O /usr/local/sbin/autobackup "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/other/backup.sh"; chmod +x /usr/local/sbin/autobackup;
wget -q -O /usr/local/sbin/backup "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/other/backup.sh"; chmod +x /usr/local/sbin/backup;
wget -q -O /usr/local/sbin/restore "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/other/restore.sh"; chmod +x /usr/local/sbin/restore;
wget -q -O /usr/local/sbin/change-port "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/other/port-change.sh"; chmod +x /usr/local/sbin/change-port;
wget -q -O /usr/local/sbin/clearlog "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/clearlog.sh"; chmod +x /usr/local/sbin/clearlog;
wget -q -O /usr/local/sbin/infonya "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/info.sh"; chmod +x /usr/local/sbin/infonya;
wget -q -O /usr/local/sbin/vpnscript "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/script-version.sh"; chmod +x /usr/local/sbin/vpnscript

# // Remove Not Used Files
rm -f menu-setup.sh