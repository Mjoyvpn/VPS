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
        clear;
		echo -e " ${ERROR} Please run this script as root user";
		exit 1;
fi

# // Checking Requirement Installed / No
if ! which jq > /dev/null; then
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

# // Clear Data
clear;
read -p "Input Your Backup ID : " Backup_ID
if [[ $Backup_ID == "" ]]; then
    clear;
    echo -e "${ERROR} Please input backup ID";
    exit 1;
fi

# // Restore The Backup
link="https://drive.google.com/u/4/uc?id=${Backup_ID}&export=download";
mkdir -p /root/cache-restore/;
cd /root/cache-restore/;
wget -q -O /root/cache-restore/restore.zip "${link}";
unzip -o /root/cache-restore/restore.zip > /dev/null 2>&1;
rm restore.zip;
if [[ -f /root/cache-restore/passwd ]]; then
    passed=true;
else
    cd /root/;
    rm -rf /root/cache-restore/;
    clear;
    echo -e "${ERROR} Having Error in your backup ID";
    exit 1;
fi

# // Copy the backup to destination
cp /etc/joysmark/domain.txt /root/cache-restore/domain.txt;
cp -r xray-mini /etc/;
cp -r joysmark /etc/;
cp passwd /etc/passwd;
cp group /etc/group;
cp shadow /etc/shadow;
cp gshadow /etc/gshadow;
cp -r wireguard /etc/;
mv domain.txt /etc/joysmark/domain.txt;
cd /root/;
rm -rf /root/cache-restore/;

# // Configuration Domain
domain=$( cat /etc/joysmark/domain.txt );
if [[ $domain == "" ]]; then
    clear;
    echo -e "${ERROR} Your Domain no detected.";
    exit 1;
fi

# // Change XRay Certificate Path
key_path_default=$( cat /etc/xray-mini/tls.json | jq '.inbounds[0].streamSettings.xtlsSettings.certificates[]' | jq -r '.certificateFile' );
cp /etc/xray-mini/tls.json /etc/xray-mini/tls.json_temp;
cat /etc/xray-mini/tls.json_temp | jq 'del(.inbounds[0].streamSettings.xtlsSettings.certificates[] | select(.certificateFile == "'${key_path_default}'"))' > /etc/xray-mini/tls2.json_temp;
cat /etc/xray-mini/tls2.json_temp | jq '.inbounds[0].streamSettings.xtlsSettings.certificates += [{"certificateFile": "'/root/.acme.sh/${domain}_ecc/fullchain.cer'","keyFile": "'/root/.acme.sh/${domain}_ecc/${domain}.key'"}]' > /etc/xray-mini/tls.json;
rm -rf /etc/xray-mini/tls2.json_temp;
rm -rf /etc/xray-mini/tls.json_temp;

# // Restarting Service
sleep 3;
systemctl restart xray-mini@tls;
systemctl restart xray-mini@socks;
systemctl restart xray-mini@http;
systemctl restart xray-mini@nontls;
systemctl restart wg-quick@wg0;
systemctl restart stunnel5;
systemctl restart vmess-kill;
systemctl restart vless-kill;
systemctl restart trojan-kill;
systemctl restart ss-kill;
systemctl restart ssh-kill;

# // Done
clear;
echo -e "${OKEY} Successfull Restores Backup to your vps";
exit 1;