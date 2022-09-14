#!/bin/bash
# (C) Copyright 2021-2022 By JoySmark
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
    rm -f /root/ssh-ssl.sh;
    rm -f /root/requirement.sh;
    rm -f /root/nginx.sh;
    rm -f /root/setup.sh;
    clear;
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


# // Replace Pam.d password common
wget -q -O /etc/pam.d/common-password "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Config/password";
chmod +x /etc/pam.d/common-password;

# // Installing Dropbear
wget -q -O /etc/ssh/sshd_config "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Config/sshd_config";
/etc/init.d/ssh restart;
apt install dropbear -y;
wget -q -O /etc/default/dropbear "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Config/dropbear_conf";
chmod +x /etc/default/dropbear;
echo "/bin/false" >> /etc/shells;
echo "/usr/sbin/nologin" >> /etc/shells;
wget -q -O /etc/joysmark/banner.txt "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Config/banner.txt";
/etc/init.d/dropbear restart;

# // Installing Stunnel4
apt install stunnel4 -y
wget -q -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Config/stunnel_conf";
wget -q -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Data/stunnel_cert";
systemctl enable stunnel4;
systemctl start stunnel4;
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart;

# // Installing Ws-ePro
wget -q -O /usr/local/joysmark/ws-epro "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Core/ws-epro";
chmod +x /usr/local/joysmark/ws-epro;
wget -q -O /etc/systemd/system/ws-epro.service "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Service/ws-epro_service";
chmod +x /etc/systemd/system/ws-epro.service;
wget -q -O /etc/joysmark/ws-epro.conf "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Config/ws-epro_conf";
chmod 644 /etc/joysmark/ws-epro.conf;
systemctl enable ws-epro;
systemctl start ws-epro;
systemctl restart ws-epro;

# // Instaling SSLH
apt install sslh -y;
wget -q -O /lib/systemd/system/sslh.service "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Service/sslh_service"
systemctl daemon-reload
systemctl disable sslh > /dev/null 2>&1;
systemctl stop sslh > /dev/null 2>&1;
systemctl enable sslh;
systemctl start sslh;
systemctl restart sslh;

# // Remove not used file
rm -f /root/ssh-ssl.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed Stunnel & Dropbear";