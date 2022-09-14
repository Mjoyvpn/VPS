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
export AUTHER="WildyDev21";
export ROOT_DIRECTORY="/etc/wildydev21";
export CORE_DIRECTORY="/usr/local/wildydev21";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://releases.wildydev21.com/vpn-script";
export REPO_URL="https://repository.wildydev21.com";

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
wget -qO- --inet4-only 'https://releases.wildydev21.com/vpn-script/get-ip_sh' | bash;
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

# // String
user_tag="$1";
exp_tag="$3";
username="$2";
expired="$4";

if [[ $user_tag == "--user" ]]; then
    SKIP=TRUE;
else
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi
if [[ $exp_tag == "--exp" ]];  then
    SKIP=TRUE;
else
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi
if [[ $username == "" ]]; then
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi
if [[ $expired == "" ]]; then
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi

# // Input Data
Username=$username;
Jumlah_Hari=$expired;

# // Creating User database file
touch /etc/xray-mini/client.conf;

# // Expired Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Generate New UUID & Domain
domain=$( cat /etc/joysmark/domain.txt );

# // Force create folder for fixing account wasted
mkdir -p /etc/joysmark/cache/;
mkdir -p /etc/xray-mini/;
mkdir -p /etc/joysmark/xray-mini-tls/;

# // Getting Vmess port using grep from config
tls_port=$( cat /etc/xray-mini/tls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );

export CHK=$( cat /etc/xray-mini/tls.json );
if [[ $CHK == "" ]]; then
    clear;
    echo -e "${ERROR} Your VPS Crash, Contact admin for fix it";
    exit 1;
fi

# // Input Your Data to server
cp /etc/xray-mini/tls.json /etc/joysmark/xray-mini-utils/tls-backup.json;
cat /etc/joysmark/xray-mini-utils/tls-backup.json | jq '.inbounds[0].settings.clients += [{"password": "'${Username}'","flow": "xtls-rprx-direct","email":"'${Username}'","level": 0 }]' > /etc/joysmark/xray-mini-cache.json;
cat /etc/joysmark/xray-mini-cache.json | jq '.inbounds[1].settings.clients += [{"password": "'${Username}'","email":"'${Username}'" }]' > /etc/wildydev21/xray-mini-cache2.json;
cat /etc/joysmark/xray-mini-cache2.json | jq '.inbounds[4].settings.clients += [{"password": "'${Username}'","email":"'${Username}'" }]' > /etc/xray-mini/tls.json;
echo -e "Trojan $Username $exp" >> /etc/xray-mini/client.conf;

# // Make Configruation Link
grpc_link="trojan://${Username}@${domain}:${tls_port}?mode=gun&security=tls&type=grpc&serviceName=Trojan-GRPC#${Username}";
tcp_tls_link="trojan://${Username}@${domain}:${tls_port}?security=tls&headerType=none&type=tcp#${Username}";
ws_tls_link="trojan://${Username}@${domain}:${tls_port}?path=%2Ftrojan&security=tls&type=ws#${Username}";

# // Restarting XRay Service
systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;
systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;
systemctl restart xray-mini@tls;
systemctl restart xray-mini@nontls;

# // Make Client Folder for save the configuration
mkdir -p /etc/joysmark/trojan/;
mkdir -p /etc/joysmark/trojan/${Username};
rm -f /etc/joysmark/trojan/${Username}/config.log;

# // Success
sleep 1;
clear;
echo -e "Create From Panel | Trojan" | tee -a /etc/joysmark/shadowsocks/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " Remarks     = ${Username}" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " IP          = ${IP_NYA}" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " Address     = ${domain}" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " Port        = ${tls_port}" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " Password    = ${Username}" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " GRPC TROJAN CONFIG LINK" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e ' ```'${grpc_link}'```' | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " TCP TLS TROJAN CONFIG LINK" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e ' ```'${tcp_tls_link}'```' | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " WS TLS TROJAN CONFIG LINK" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e ' ```'${ws_tls_link}'```' | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " Created     = ${hariini}" | tee -a /etc/joysmark/trojan/${Username}/config.log;
echo -e " Expired     = ${exp}";
echo -e "===============================";