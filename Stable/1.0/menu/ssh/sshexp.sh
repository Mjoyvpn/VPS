#!/bin/bash
# (C) Copyright 2021-2022 By joysmark
# ==================================================================
# Name        : VPN Script Quick Installation Script
# Description : This Script Is Setup for running other
#               quick Setup script from one click installation
# Created     : 16-05-2022 ( 16 May 2022 )
# OS Support  : Ubuntu & Debian
# Auther      : joysmark
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

# // Clear Expired User
clear;
hariini=`date +%d-%m-%Y`;
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /etc/wildydev21/akun-ssh.db
totalaccounts=`cat /etc/wildydev21/akun-ssh.db | wc -l` 
echo "Total Akun = $totalaccounts" > /etc/wildydev21/total-akun-ssh.db
for((i=1; i<=$totalaccounts; i++ ))
do
    tuserval=`head -n $i /etc/wildydev21/akun-ssh.db | tail -n 1`
    username=`echo $tuserval | cut -f1 -d:`
    userexp=`echo $tuserval | cut -f2 -d:`
    userexpireinseconds=$(( $userexp * 86400 ))
    tglexp=`date -d @$userexpireinseconds`             
    tgl=`echo $tglexp |awk -F" " '{print $3}'`
while [ ${#tgl} -lt 2 ]
do
    tgl="0"$tgl
done
while [ ${#username} -lt 15 ]
do
    username=$username" " 
done
    bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
    echo "echo 'User : $username | Expired : $tgl $bulantahun'" >> /etc/wildydev21/ssh-user-cache.db
    todaystime=`date +%s`
if [ $userexpireinseconds -ge $todaystime ]; then
    SKip="true"
else
    echo "Username : $username | Expired : $tgl $bulantahun | Deleted $hariini" >> /etc/wildydev21/ssh-expired-deleted.db
    echo "Username : $username | Expired : $tgl $bulantahun | Deleted $hariini"
    userdel -f $username;
    rm -rf /etc/wildydev21/ssh/${username};
fi
done
