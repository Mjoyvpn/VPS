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
       
# // Start
clear;
echo -e "${RED_BG}                    AutoKill Multi Login                  ${NC}";
echo -e "${GREEN} 1${YELLOW})${NC}. Set Vmess XRay VPN Autokill";
echo -e "${GREEN} 2${YELLOW})${NC}. Set Vless XRay VPN Autokill";
echo -e "${GREEN} 3${YELLOW})${NC}. Set Trojan XRay VPN Autokill";
echo -e "${GREEN} 4${YELLOW})${NC}. Set Shadowsocks XRay VPN Autokill";
echo -e "${GREEN} 5${YELLOW})${NC}. Set SSH Multi Login Autokill";
echo -e "${GREEN} 6${YELLOW})${NC}. Enable AutoKill Service";
echo -e "${GREEN} 7${YELLOW})${NC}. Disable AutoKill Service";
echo -e "${GREEN} 8${YELLOW})${NC}. Restart Autokill Service";
echo "";
read -p "Please Choose one : " selection_mu;

node_name=ss;

case $selection_mu in
    1)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on vmess uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in vmess";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "New Limit for vmess auto kill : " killvmess_coy
        if [[ $killvmess_coy == "" ]]; then
            clear;
            echo -e "${ERROR} Please input autokill limit size";
            exit 1;
        fi
        source /etc/joysmark/autokill.conf
        if [[ $VMESS == "" ]]; then
            clear;
            echo -e "${ERROR} Your Autokill Config have error";
            exit 1;
        fi
        sed -i "s/VMESS=${VMESS}/VMESS=${killvmess_coy}/g" /etc/joysmark/autokill.conf;
        systemctl restart vmess-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Successfull Set Vmess XRay VPN AutoKill";
    ;;
    2)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on vless uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in vless";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "New Limit for vless auto kill : " killvless_coy
        if [[ $killvless_coy == "" ]]; then
            clear;
            echo -e "${ERROR} Please input autokill limit size";
            exit 1;
        fi
        source /etc/joysmark/autokill.conf
        if [[ $VLESS == "" ]]; then
            clear;
            echo -e "${ERROR} Your Autokill Config have error";
            exit 1;
        fi
        sed -i "s/VLESS=${VLESS}/VLESS=${killvless_coy}/g" /etc/joysmark/autokill.conf;
        systemctl restart vless-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Successfull Set Vless XRay VPN AutoKill";
    ;;
    3)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on trojan uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in trojan";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "New Limit for trojan auto kill : " killtrojan_coy
        if [[ $killtrojan_coy == "" ]]; then
            clear;
            echo -e "${ERROR} Please input autokill limit size";
            exit 1;
        fi
        source /etc/joysmark/autokill.conf
        if [[ $TROJAN == "" ]]; then
            clear;
            echo -e "${ERROR} Your Autokill Config have error";
            exit 1;
        fi
        sed -i "s/TROJAN=${TROJAN}/TROJAN=${killtrojan_coy}/g" /etc/joysmark/autokill.conf;
        systemctl restart trojan-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Successfull Set Trojan XRay VPN AutoKill";
    ;;
    4)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on shadowsocks uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in shadowsocks";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "New Limit for shadowsocks auto kill : " killshadowsocks_cuy
        if [[ $killshadowsocks_cuy == "" ]]; then
            clear;
            echo -e "${ERROR} Please input autokill limit size";
            exit 1;
        fi
        source /etc/joysmark/autokill.conf
        if [[ $SHADOWSOCKS == "" ]]; then
            clear;
            echo -e "${ERROR} Your Autokill Config have error";
            exit 1;
        fi
        sed -i "s/SHADOWSOCKS=${SHADOWSOCKS}/SHADOWSOCKS=${killshadowsocks_cuy}/g" /etc/wildydev21/autokill.conf;
        systemctl restart ss-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Successfull Set Shadowsocks XRay VPN AutoKill";
    ;;
    5)
        clear;
        read -p "New Limit for SSH auto kill : " ssh_kill
        if [[ $ssh_kill == "" ]]; then
            clear;
            echo -e "${ERROR} Please input autokill limit size";
            exit 1;
        fi
        source /etc/joysmark/autokill.conf
        if [[ $SSH == "" ]]; then
            clear;
            echo -e "${ERROR} Your Autokill Config have error";
            exit 1;
        fi
        sed -i "s/SSH=${SSH}/SSH=${ssh_kill}/g" /etc/joysmark/autokill.conf;
        systemctl restart ssh-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Successfull Set SSH MultiLogin Autokill";
    ;;
    6)
        source /etc/joysmark/autokill.conf
        if [[ $ENABLED == "" ]]; then
            clear;
            echo -e "${ERROR} Your Autokill Config have error";
            exit 1;
        fi
        sed -i "s/ENABLED=${ENABLED}/ENABLED=1/g" /etc/joysmark/autokill.conf;
        systemctl restart vmess-kill > /dev/null 2>&1;
        systemctl restart vless-kill > /dev/null 2>&1;
        systemctl restart ss-kill > /dev/null 2>&1;
        systemctl restart trojan-kill > /dev/null 2>&1;
        systemctl restart ssh-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Successfull Enabled Autokill";
    ;;
    7)
        source /etc/joysmark/autokill.conf
        if [[ $ENABLED == "" ]]; then
            clear;
            echo -e "${ERROR} Your Autokill Config have error";
            exit 1;
        fi
        sed -i "s/ENABLED=${ENABLED}/ENABLED=0/g" /etc/joysmark/autokill.conf;
        systemctl restart vmess-kill > /dev/null 2>&1;
        systemctl restart vless-kill > /dev/null 2>&1;
        systemctl restart ss-kill > /dev/null 2>&1;
        systemctl restart trojan-kill > /dev/null 2>&1;
        systemctl restart ssh-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Successfull Disabled Autokill";
        exit;
    ;;
    8)
        systemctl restart vmess-kill > /dev/null 2>&1
        systemctl restart vless-kill > /dev/null 2>&1
        systemctl restart ss-kill > /dev/null 2>&1
        systemctl restart trojan-kill > /dev/null 2>&1
        systemctl restart ssh-kill > /dev/null 2>&1
        clear;
        echo -e "${OKEY} Successfull Restarted AutoKill Service";
        exit 1;
    ;;
    *)
        echo -e "${ERROR} Your Input is Wrong";
        sleep 1;
        autokill-menu;
    ;;
esac