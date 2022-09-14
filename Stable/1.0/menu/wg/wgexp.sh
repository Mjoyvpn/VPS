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

# // String For User Data Option
grep -c -E "^#DEPAN " "/etc/wireguard/wg0.conf" > /etc/joysmark/jumlah-akun-wireguard.db;
grep "^#DEPAN " "/etc/wireguard/wg0.conf" | cut -d ' ' -f 4  > /etc/joysmark/akun-wireguard.db;
totalaccounts=`cat /etc/joysmark/akun-wireguard.db | wc -l`;
echo "Total Akun = $totalaccounts" > /etc/joysmark/total-akun-wireguard.db;
for((i=1; i<=$totalaccounts; i++ ));
do
    # // Username Interval Counting
    username=`head -n $i /etc/joysmark/akun-wireguard.db | tail -n 1`;
    expired=$( cat /etc/wireguard/wg0.conf | grep -w $username | head -n1 | awk '{print $8}' );

    # // Counting On Simple Algoritmatika
    now=`date -d "0 days" +"%Y-%m-%d"`;
    d1=$(date -d "$expired" +%s);
    d2=$(date -d "$now" +%s);
    sisa_hari=$(( (d1 - d2) / 86400 ));

    # // String For Do Task
    client="$username";
    expired="$expired";

# // Validate Use If Syntax
if [[ $sisa_hari -lt 1 ]]; then
    # // Removing Data From Server Configuration
    sed -i "/^#DEPAN Username : $client | Expired : $expired/,/^#BELAKANG Username : $client | Expired : $expired/d" /etc/wireguard/wg0.conf;
    rm -f /etc/joysmark/webserver/wg-client/$client.conf;
    rm -rf /etc/joysmark/wireguard/$client;

    # // Restarting Wireguard Service
    systemctl daemon-reload;
    systemctl restart wg-quick@wg0;

    # // Successfull Deleted Expired Client
    echo "Username : $username | Expired : $expired | Deleted $now" >> /etc/joysmark/wireguard-expired-deleted.db;
    echo "Username : $username | Expired : $expired | Deleted $now";
else
    Skip="true";
fi

# // End Function
done