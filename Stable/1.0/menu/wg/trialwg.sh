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

# // Generate Username
Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )";
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )"; # > // Filtering If User Type Space

# // Validating Your Username Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "${ERROR} Please Input Username";
    exit 1;
fi

if [[ $( cat /etc/wireguard/wg0.conf | grep -w $Username ) == "" ]]; then
    Skip=true;
else
    clear;
    echo -e "${ERROR} User ( ${YELLOW}$Username${NC} ) Already Exists !";
    exit 1;
fi

# // Read Expired Date
Jumlah_Hari=1;

# // Count Expired Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Load Wiregaurd String
source /etc/wireguard/string-data;

# // Checknig IP Address
LASTIP=$( cat /etc/wireguard/wg0.conf | grep /32 | tail -n1 | awk '{print $3}' | cut -d "/" -f 1 | cut -d "." -f 4 );
if [[ "$LASTIP" = "" ]]; then
	User_IP="10.10.17.2";
else
	User_IP="10.10.17.$((LASTIP+1))";
fi

# // Client DNS
DNS1=8.8.8.8;
DNS2=8.8.4.4;

# // Domain Export
Domain=$( cat /etc/joysmark/domain.txt );

# // Generate Client Key
User_Priv_Key=$(wg genkey);
User_PUB_Key=$(echo "$User_Priv_Key" | wg pubkey);
User_Preshared_Key=$(wg genpsk);

# // Make Client Config
cat > /etc/joysmark/wireguard-cache.tmp << END
[Interface]
PrivateKey = ${User_Priv_Key}
Address = ${User_IP}/24
DNS = ${DNS1},${DNS2}

[Peer]
PublicKey = ${PUB}
PresharedKey = ${User_Preshared_Key}
Endpoint = ${Domain}:${PORT}
AllowedIPs = 0.0.0.0/0,::/0
END

# // Input Data User Ke Wireguard Server
cat >> /etc/wireguard/wg0.conf << END
#DEPAN Username : $Username | Expired : $exp
[Peer]
Publickey = ${User_PUB_Key}
PresharedKey = ${User_Preshared_Key}
AllowedIPs = ${User_IP}/32
#BELAKANG Username : $Username | Expired : $exp

END

# // Make Wireguard cache folder
mkdir -p /etc/joysmark/wireguard/;
rm -rf /etc/joysmark/wireguard/$Username;
mkdir -p /etc/joysmark/wireguard/$Username;

# // Restarting Service & Copy Client data to webserver
systemctl restart "wg-quick@wg0";
sysctl -p
cp /etc/joysmark/wireguard-cache.tmp /etc/joysmark/webserver/wg-client/${Username}.conf;

# // Clear
clear;

# // Detail
echo -e "Your Trial Wireguard Details" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e " Username    = ${Username}" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e " IP          = ${IP}" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e " Address     = ${Domain}" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e " Config File = http://${IP}:85/wg-client/${Username}.conf" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e "===============================" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e " Created     = ${hariini}" | tee -a /etc/joysmark/wireguard/${Username}/config.log;
echo -e " Expired     = ${exp}";
echo -e "===============================";