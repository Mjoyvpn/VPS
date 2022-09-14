#!/bin/bash
# (C) Copyright 2021-2022 By joysmark
# ==================================================================
# Name        : VPN Script Quick Installation Script
# Description : This Script Is Setup for running other
#               quick Setup script from one click installation
# Created     : 16-05-2022 ( 16 May 2022 )
# OS Support  : Ubuntu & Debian
# Auther      : joysmark
# WebSite     : https://r.me/joysmark
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
clear

# // Start
clear;
echo -n > /tmp/other.txt;
echo -n > /etc/joysmark/cache/vmess_temp.txt;
echo -n > /etc/joysmark/cache/vmess_temp2.txt;
data=(`cat /etc/xray-mini/client.conf | grep '^Vmess' | cut -d " " -f 2`);
echo "=============================================";
echo "             WebSocket TLS Login";
echo "=============================================";
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada";
fi
echo -n > /etc/joysmark/cache/vmess_temp.txt;
data2=( `netstat -anp | grep ESTABLISHED | grep 'tcp6\|udp6' | grep xray-mini | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /etc/joysmark/xray-mini-tls/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq);
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /etc/joysmark/cache/vmess_temp.txt;
else
echo "$ip" >> /etc/joysmark/cache/vmess_temp2.txt;
fi
jum2=$(cat /etc/joysmark/cache/vmess_temp.txt);
sed -i "/$jum2/d" /etc/joysmark/cache/vmess_temp2.txt > /dev/null 2>&1;
done
jum=$(cat /etc/joysmark/cache/vmess_temp.txt);
if [[ -z "$jum" ]]; then
echo > /dev/null;
else
jum2=$(cat /etc/joysmark/cache/vmess_temp.txt | nl);
hariini=`date -d "0 days" +"%Y-%m-%d"`;
echo "Username : $akun";
echo "$jum2";
echo "";
fi
done
echo "=============================================";
echo "           WebSocket NonTLS Login";
echo "=============================================";
echo -n > /etc/joysmark/cache/vmess_temp3.txt;
data=(`cat /etc/xray-mini/client.conf | grep '^Vmess' | cut -d " " -f 2`);
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada";
fi
ip=$( cat /etc/joysmark/xray-mini-nontls/access.log | grep "$(date -d "0 days" +"%H:%M" )" | grep -w $akun | tail -n100 | awk '{print $3}' | cut -d: -f1 | sort | uniq );
if [[ -z "$ip" ]]; then
echo > /dev/null
else
jum5=$(echo $ip | nl);
hariini=`date -d "0 days" +"%Y-%m-%d"`;
echo "Username : $akun";
echo "$jum5";
echo "";
fi
done
echo "=============================================";
echo "            GRPC IP Login List";
echo "=============================================";
oth=$(cat /etc/joysmark/cache/vmess_temp2.txt | sort | uniq | nl )
echo "GRPC IP : All User IP";
echo "$oth";
echo "=============================================";
echo "";
rm -rf /etc/joysmark/cache/vmess_temp2.txt;
rm -rf /etc/joysmark/cache/vmess_temp.txt;
rm -rf /etc/joysmark/cache/vmess_temp3.txt;