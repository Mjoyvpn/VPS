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


# // Clear Data
clear;

# // Start Menu
echo " List Of Avaiable ShadowsocksR Protocols";
echo "===============================================";
echo "  1. origin";
echo "  2. auth_sha1";
echo "  3. auth_sha1_v2";
echo "  4. auth_sha1_v4";
echo "===============================================";
read -p "Choose One Protocols You Want Use ( 1-4 ) : " choose_protocols;
case $choose_protocols in
    1) # Origin
        Protocols="origin";
    ;;
    2) # auth_sha1
        Protocols="auth_sha1";
    ;;
    3) # auth_sha1_v2
        Protocols="auth_sha1_v2";
    ;;
    4) # auth_sha1_v4
        Protocols="auth_sha1_v4";
    ;;
    *) # No Choose
        clear;
        echo -e "${ERROR} Please Choose One Protocols !";
        exit 1;
    ;;
esac

# // Clear
clear;

# // Choose Obfs
echo " List Of Avaiable ShadowsocksR Obfs";
echo "===============================================";
echo " 1. plain";
echo " 2. http_simple";
echo " 3. http_post";
echo " 4. tls_simple";
echo " 5. tls1.2_ticket_auth";
echo "===============================================";
read -p "Choose One Obfs You Want Use ( 1-5 ) : " choose_obfs;
case $choose_obfs in
    1) # plain
        obfs="plain";
    ;;
    2) # http_simple
        obfs="http_simple";
    ;;
    3) # http_post
        obfs="http_post";
    ;;
    4) # tls_simple
        obfs="tls_simple";
    ;;
    5) # tls1.2_ticket_auth_compatible
        obfs="tls1.2_ticket_auth_compatible";
    ;;
    *) # No Choose
        clear;
        echo -e "${ERROR} Please Choose One Obfs !";
        exit 1;
    ;;
esac

clear;
Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )";
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )"; # > // Filtering If User Type Space

touch /etc/joysmark/ssr-client.conf
if [[ $Username == "$( cat /etc/joysmark/ssr-client.conf | grep -w $Username | head -n1 | awk '{print $2}' )" ]]; then
clear;
echo -e "${ERROR} Account With ( ${YELLOW}$Username ${NC}) Already Exists !";
exit 1;
fi
Domain=$( cat /etc/joysmark/domain.txt );

# // Configure For Trial
max_log=1
Jumlah_Hari=1
bandwidth_allowed=1

# // Count Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Port Configuration
if [[ $(cat /etc/joysmark/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) == "" ]]; then
Port=1200;
else
Port=$(( $(cat /etc/joysmark/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) + 1 ));
fi

# // Adding User To Configuration
echo -e "SSR $Username $exp $Port" >> /etc/joysmark/ssr-client.conf;

# // Adding User To ShadowsocksR Server
cd /etc/joysmark/ssr-server/;
match_add=$(python mujson_mgr.py -a -u "${Username}" -p "${Port}" -k "${Username}" -m "aes-256-cfb" -O "${Protocols}" -G "${max_log}" -o "${obfs}" -s "0" -S "0" -t "${bandwidth_allowed}" -f "bittorrent" | grep -w "add user info");
cd;

# // Make Client Configuration Link
tmp1=$(echo -n "${Username}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g');
SSRobfs=$(echo ${obfs} | sed 's/_compatible//g');
tmp2=$(echo -n "${IP}:${Port}:${Protocols}:aes-256-cfb:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0);
ssr_link="ssr://${tmp2}";

# // Restarting Service
/etc/init.d/ssr-server restart;

# // Make Cache Folder
rm -rf /etc/joysmark/ssr/${Username};
mkdir -p /etc/joysmark/ssr/${Username}/

# // Clear
clear;

# // Successfull
echo "Your Trial ShadowsocksR" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo "==============================" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " IP         = "'```'"${IP}"'```'"" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Domain     = $Domain" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Username   = $Username" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Password   = $Username" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Port       = $Port" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Protocols  = $Protocols" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Obfs       = $obfs" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Max Login  = $max_log Device" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " BW Limit   = 1 GB" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo "==============================" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " ShadowsocksR Config Link" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo ' ```'$ssr_link'```' | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo "==============================" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Created    = $hariini" | tee -a /etc/joysmark/ssr/${Username}/config.log;
echo " Expired    = $exp";
echo "==============================";