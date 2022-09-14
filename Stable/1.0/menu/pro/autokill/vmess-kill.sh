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


# // Rending Your License data from json
export RESPON_CODE=$( echo ${API_REQ_NYA} | jq -r '.respon_code' );
export IP=$( echo ${API_REQ_NYA} | jq -r '.ip' );
export STATUS_IP=$( echo ${API_REQ_NYA} | jq -r '.status2' );
export STATUS_LCN=$( echo ${API_REQ_NYA} | jq -r '.status' );
export PELANGGAN_KE=$( echo ${API_REQ_NYA} | jq -r '.id' );
export TYPE=$( echo ${API_REQ_NYA} | jq -r '.type' );
export COUNT=$( echo ${API_REQ_NYA} | jq -r '.count' );
export LIMIT=$( echo ${API_REQ_NYA} | jq -r '.limit' );
export CREATED=$( echo ${API_REQ_NYA} | jq -r '.created' );
export EXPIRED=$( echo ${API_REQ_NYA} | jq -r '.expired' );
export UNLIMITED=$( echo ${API_REQ_NYA} | jq -r '.unlimited' );
export LIFETIME=$( echo ${API_REQ_NYA} | jq -r '.lifetime' );
export STABLE=$( echo ${API_REQ_NYA} | jq -r '.stable' );
export BETA=$( echo ${API_REQ_NYA} | jq -r '.beta' );
export FULL=$( echo ${API_REQ_NYA} | jq -r '.full' );
export LITE=$( echo ${API_REQ_NYA} | jq -r '.lite' );
export NAME=$( echo ${API_REQ_NYA} | jq -r '.name' );

# // Validate Expired
if [[ ${LIFETIME} == "true" ]]; then
    SKIP=true;
else
    waktu_sekarang=$(date -d "0 days" +"%Y-%m-%d");
    expired_date="$EXPIRED";
    now_in_s=$(date -d "$waktu_sekarang" +%s);
    exp_in_s=$(date -d "$expired_date" +%s);
    days_left=$(( ($exp_in_s - $now_in_s) / 86400 ));
    if [[ $days_left -lt 0 ]]; then
        clear;
        
# // Clear Data
clear;

# // Inputing Max Login				
source /etc/joysmark/autokill.conf;
if [[ $ENABLED == "0" ]]; then
    clear;
    echo -e "$(date) Autokill is disabled";
    exit 1;
elif [[ $ENABLED == "1" ]]; then
    ENABLECOY=true;
else
    clear;
    echo -e "$(date) Configuration not found";
    exit 1;
fi

if [[ $VMESS == "" ]]; then
        echo -e "$(date) Vmess Autokill No Setuped.";
fi

# // Start
echo "$(date) Autokill Vmess MultiLogin for joysmark Script V1.0 Stable";
echo "$(date) Coded by joysmark ( Version 1.0 Beta )";
echo "$(date) Starting Vmess Autokill Service.";

while true; do
sleep 30
# // Start
grep -c -E "^Vmess " "/etc/xray-mini/client.conf" > /etc/joysmark/jumlah-akun-vmess.db;
grep "^Vmess " "/etc/xray-mini/client.conf" | awk '{print $2}'  > /etc/joysmark/akun-vmess.db;
totalaccounts=`cat /etc/joysmark/akun-vmess.db | wc -l`;
echo "Total Akun = $totalaccounts" > /etc/joysmark/total-akun-vmess.db;
for((i=1; i<=$totalaccounts; i++ ));
do
    # // Username Interval Counting
    username=$( head -n $i /etc/joysmark/akun-vmess.db | tail -n 1 );
    expired=$( grep "^Vmess " "/etc/xray-mini/client.conf" | grep -w $username | head -n1 | awk '{print $3}' );

    # // Creating Cache for access.log
    cat /etc/joysmark/xray-mini-nontls/access.log | tail -n30000 > /etc/joysmark/xray-mini-nontls/cache.log

    # // Configuration user logs
    hariini=`date -d "0 days" +"%Y/%m/%d"`;
    waktu=`date -d "0 days" +"%H:%M"`;
    waktunya=`date -d "0 days" +"%Y/%m/%d %H:%M"`;
    jumlah_baris_log=$( cat /etc/joysmark/xray-mini-nontls/cache.log | grep -w $hariini | grep -w $waktu | grep -w 'accepted' | grep -w $username | wc -l );

    if [[ $jumlah_baris_log -gt $VMESS ]]; then
        cp /etc/xray-mini/tls.json /etc/joysmark/xray-mini-utils/tls-backup.json;
        cat /etc/joysmark/xray-mini-utils/tls-backup.json | jq 'del(.inbounds[2].settings.clients[] | select(.email == "'${username}'"))' > /etc/joysmark/xray-mini-cache.json;
        cat /etc/joysmark/xray-mini-cache.json | jq 'del(.inbounds[5].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/tls.json;
        cp /etc/xray-mini/nontls.json /etc/joysmark/xray-mini-utils/nontls-backup.json;
        cat /etc/joysmark/xray-mini-utils/nontls-backup.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/nontls.json;
        rm -rf /etc/joysmark/vmess/${username};
        sed -i "/\b$username\b/d" /etc/xray-mini/client.conf;
        systemctl restart xray-mini@tls;
        systemctl restart xray-mini@nontls;
        date=`date +"%X"`;
        echo "$(date) ${username} - Multi Login Detected - Killed at ${date}"
        echo "VMESS - $(date) - ${username} - Multi Login Detected - Killed at ${date}" >> /etc/joysmark/autokill.log;
    fi

    # // Creating Cache for access.log
    cat /etc/joysmark/xray-mini-tls/access.log | tail -n30000 > /etc/joysmark/xray-mini-tls/cache.log

    # // Configuration user logs
    hariini=`date -d "0 days" +"%Y/%m/%d"`;
    waktu=`date -d "0 days" +"%H:%M"`;
    waktunya=`date -d "0 days" +"%Y/%m/%d %H:%M"`;
    jumlah_baris_log=$( cat /etc/joysmark/xray-mini-tls/cache.log | grep -w $hariini | grep -w $waktu | grep -w 'accepted' | grep -w $username | wc -l );

    if [[ $jumlah_baris_log -gt $VMESS ]]; then
        cp /etc/xray-mini/tls.json /etc/joysmark/xray-mini-utils/tls-backup.json;
        cat /etc/joysmark/xray-mini-utils/tls-backup.json | jq 'del(.inbounds[2].settings.clients[] | select(.email == "'${username}'"))' > /etc/joysmark/xray-mini-cache.json;
        cat /etc/joysmark/xray-mini-cache.json | jq 'del(.inbounds[5].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/tls.json;
        cp /etc/xray-mini/nontls.json /etc/joysmark/xray-mini-utils/nontls-backup.json;
        cat /etc/joysmark/xray-mini-utils/nontls-backup.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/nontls.json;
        rm -rf /etc/joysmark/vmess/${username};
        sed -i "/\b$username\b/d" /etc/xray-mini/client.conf;
        systemctl restart xray-mini@tls;
        systemctl restart xray-mini@nontls;
        date=`date +"%X"`;
        echo "$(date) ${username} - Multi Login Detected - Killed at ${date}"
        echo "VMESS - $(date) - ${username} - Multi Login Detected - Killed at ${date}" >> /etc/joysmark/autokill.log;
    fi
# // End Function
done
done