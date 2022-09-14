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
# License     : MIT License
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
        echo -e "${ERROR} Your License Key expired";
        exit 1;
    else
        export DAYS_LEFT=${days_left};
    fi
fi

# // Validate Your IP is activated or no
if [[ $STATUS_IP == "active" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Your IP Not Registered";
    exit 1;
fi

# // Validate Your License is active or no
if [[ $STATUS_LCN == "active" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Your License key not active";
    exit 1;
fi

# // Clear Data
clear;

# // Input Data
clear;
read -p "Username : " Username;
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )";

# // Validate Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "${EROR} Please Input an Username !";
    exit 1;
fi

# // Creating User database file
touch /etc/xray-mini/client.conf;

# // Checking User already on vps or no
if [[ "$( cat /etc/xray-mini/client.conf | grep -w ${Username})" == "" ]]; then
    Do=Nothing;
else
    clear;
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !";
    exit 1;
fi

# // Expired Date
read -p "Expired  : " Jumlah_Hari;
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Generate New UUID & Domain
uuid=$( cat /proc/sys/kernel/random/uuid );
domain=$( cat /etc/joysmark/domain.txt );

# // Force create folder for fixing account wasted
mkdir -p /etc/joysmark/cache/;
mkdir -p /etc/xray-mini/;
mkdir -p /etc/joysmark/xray-mini-tls/;
mkdir -p /etc/joysmark/xray-mini-nontls/;

# // Getting Vmess port using grep from config
tls_port=$( cat /etc/xray-mini/tls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );
nontls_port=$( cat /etc/xray-mini/nontls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );

export CHK=$( cat /etc/xray-mini/tls.json );
if [[ $CHK == "" ]]; then
    clear;
    echo -e "${ERROR} Your VPS Crash, Contact admin for fix it";
    exit 1;
fi

# // Input Your Data to server
cp /etc/xray-mini/tls.json /etc/joysmark/xray-mini-utils/tls-backup.json;
cat /etc/joysmark/xray-mini-utils/tls-backup.json | jq '.inbounds[2].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'","alterid": '"0"'}]' > /etc/joysmark/xray-mini-cache.json;
cat /etc/joysmark/xray-mini-cache.json | jq '.inbounds[5].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'","alterid": '"0"'}]' > /etc/xray-mini/tls.json;
cp /etc/xray-mini/nontls.json /etc/joysmark/xray-mini-utils/nontls-backup.json;
cat /etc/joysmark/xray-mini-utils/nontls-backup.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'","alterid": '"0"'}]' > /etc/xray-mini/nontls.json;
echo -e "Vmess $Username $exp" >> /etc/xray-mini/client.conf;

cat > /etc/joysmark/cache/vmess-tls-gun.tmp << END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"grpc","path":"Vmess-GRPC","port":"${tls_port}","ps":"${Username}","scy":"none","sni":"","tls":"tls","type":"gun","v":"2"}
END

cat > /etc/joysmark/cache/vmess-tls-ws.tmp << END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"ws","path":"/vmess","port":"${tls_port}","ps":"${Username}","scy":"none","sni":"${domain}","tls":"tls","type":"","v":"2"}
END

cat > /etc/joysmark/cache/vmess-nontls.tmp << END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"ws","path":"/vmess","port":"${nontls_port}","ps":"${Username}","scy":"none","sni":"","tls":"","type":"","v":"2"}
END


cat > /etc/joysmark/cache/vmess-tls-gun.tmp << END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"grpc","path":"Vmess-GRPC","port":"${tls_port}","ps":"${Username}","scy":"none","sni":"","tls":"tls","type":"gun","v":"2"}
END

cat > /etc/joysmark/cache/vmess-tls-ws.tmp << END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"ws","path":"/vmess","port":"${tls_port}","ps":"${Username}","scy":"none","sni":"${domain}","tls":"tls","type":"","v":"2"}
END

cat > /etc/joysmark/cache/vmess-nontls.tmp << END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"ws","path":"/vmess","port":"${nontls_port}","ps":"${Username}","scy":"none","sni":"","tls":"","type":"","v":"2"}
END

# // Make Config Link
grpc_link="vmess://$(base64 -w 0 /etc/joysmark/cache/vmess-tls-gun.tmp)";
ws_tls_link="vmess://$(base64 -w 0 /etc/joysmark/cache/vmess-tls-ws.tmp)";
ws_nontls_link="vmess://$(base64 -w 0 /etc/joysmark/cache/vmess-nontls.tmp)";

# // Restarting XRay Service
systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;
systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;
systemctl restart xray-mini@tls;
systemctl restart xray-mini@nontls;

# // Make Client Folder for save the configuration
mkdir -p /etc/joysmark/vmess/;
mkdir -p /etc/joysmark/vmess/${Username};
rm -f /etc/joysmark/vmess/${Username}/config.log;

# // Success
sleep 1;
clear;
echo -e "Your Premium Vmess Details" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " Remarks     = ${Username}" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " IP          = ${IP_NYA}" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " Address     = ${domain}" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " Port TLS    = ${tls_port}" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " Port NTLS   = ${nontls_port}" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " User ID     = ${uuid}" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " GRPC VMESS CONFIG LINK" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e ' ```'${grpc_link}'```' | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " WS TLS VMESS CONFIG LINK" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e ' ```'${ws_tls_link}'```' | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " WS NTLS VMESS CONFIG LINK" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e ' ```'${ws_nontls_link}'```' | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " Created     = ${hariini}" | tee -a /etc/joysmark/vmess/${Username}/config.log;
echo -e " Expired     = ${exp}";
echo -e "===============================";