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
    rm -f /root/ovpn.sh;
    rm -f /root/ssh-ssl.sh;
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
3

# // Installing Wireguard
OS=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/"//g' | awk '{print $1}' );
if [[ $OS == "ubuntu" ]]; then
	apt update -y;
	apt upgrade -y;
	apt autoremove -y;
	apt install wireguard -y;
elif [[ $OS == "debian" ]]; then
	echo "deb http://deb.debian.org/debian/ unstable main" >/etc/apt/sources.list.d/unstable.list;
	printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' >/etc/apt/preferences.d/limit-unstable;
	apt update -y;
	apt upgrade -y;
	apt autoremove -y;
	apt install wireguard-tools -y;
fi

# // Installing Requirement Tools
apt install iptables -y;
apt install iptables-persistent -y;
apt install wireguard-dkms -y;

# // Make Wireguard Directory
rm -rf /etc/wireguard;
mkdir -p /etc/wireguard;
chmod 600 -R /etc/wireguard/;

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')";

# // Generating Wiregaurd PUB Key & WG PRIV Key
PRIV_KEY=$(wg genkey);
PUB_KEY=$(echo "$PRIV_KEY" | wg pubkey);

# // Make Wireguard Config Directory
cat > /etc/wireguard/string-data << END
DIFACE=$NETWORK_IFACE
IFACE=wg0
LOCAL=10.10.17.1
PORT=2048
PRIV=$PRIV_KEY
PUB=$PUB_KEY
END

# // Wireguard Data Load
source /etc/wireguard/string-data;

# // Create Server Config
cat > /etc/wireguard/wg0.conf << END
# Wireguard Config By joysmark
# ============================================================
# Please do not try to change / modif this config
# This config is tag to wireguard service
# if you modified this the wireguard service will error
# ============================================================
# (C) Copyright 2022-2023 By joysmark

# // Start Config
[Interface]
Address = $LOCAL/24
ListenPort = $PORT
PrivateKey = $PRIV
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${DIFACE} -j MASQUERADE;
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${DIFACE} -j MASQUERADE;

#WIREGUARD
END

# // Adding Wireguard to IpTables
iptables -t nat -I POSTROUTING -s ${LOCAL}/24 -o ${DIFACE} -j MASQUERADE;
iptables -I INPUT 1 -i wg0 -j ACCEPT;
iptables -I FORWARD 1 -i ${DIFACE} -o wg0 -j ACCEPT;
iptables -I FORWARD 1 -i wg0 -o ${DIFACE} -j ACCEPT;
iptables -I INPUT 1 -i ${DIFACE} -p udp --dport ${PORT} -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save;
netfilter-persistent reload;

# // Make Client Config Directory
mkdir -p /etc/joysmark/webserver/wg-client/;

# // Starting Wireguard
systemctl enable systemd-resolved;
systemctl enable wg-quick@wg0;
systemctl start wg-quick@wg0;
systemctl restart wg-quick@wg0;

# // Remove Unused Files
rm -f /root/wg-set.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed Wireguard";