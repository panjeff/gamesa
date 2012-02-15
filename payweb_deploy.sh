#!/bin/sh
#
# The steps for upgrading pay-web:
# (1) change nginx config to remove the maintenance host
# (2) run this script
# (3) run /data/app/pay-web/shell/rs_pay.sh restart for resin restarting
#

if [ `id -u` -ne 0 ];then
   echo "must be root"
   exit
fi

mkdir -p /data/webapps/pay-web/webapp
mkdir -p /data/app/pay-web /data/pki /data/backup/hosts
mkdir -p /data2/log/resin /data2/log/nginx /data2/log/pay 
if ! id resin >/dev/null 2>&1; then
    useradd resin -d /var/www -s /usr/sbin/nologin
fi
if ! id www-data >/dev/null 2>&1; then
    useradd www-data -d /var/www -s /usr/sbin/nologin
fi

export RSYNC_PASSWORD=****
rsync -avz --delete pay@121.9.xx.xx::payweb  /data/app/pay-web/

cp -f /data/app/pay-web/config/bill99_dw-private-rsa.pfx /data/pki
cp -f /data/app/pay-web/config/bill99_public-rsa.cer /data/pki
cp -f /etc/hosts /data/backup/hosts/hosts.`date '+%Y%m%d%H%M%S'`
cp -f /data/app/pay-web/config/hosts /etc/hosts

if [ -d /usr/local/resin/lib ];then
    if [ ! -h /usr/local/resin/lib ];then 
        mv /usr/local/resin/lib /usr/local/resin/lib_old
        ln -sf /data/app/pay-web/lib/resin_lib /usr/local/resin/lib 
    else 
        rm -f /usr/local/resin/lib
        ln -sf /data/app/pay-web/lib/resin_lib /usr/local/resin/lib 
    fi
else
    echo "#################################"
    echo "resin lib missing, exit now!!!"
    echo "#################################"
    exit
fi

chown -R resin:resin /data/app/pay-web/lib/resin_lib  /data/webapps
find /data/app -type d -exec chmod 755 {} \;
find /data/app -type f -exec chmod o+r {} \;
chmod 755 /data/app/pay-web/shell/rs_pay.sh

echo
echo "#################################################################"
echo "# DONE. Run /data/app/pay-web/shell/rs_pay.sh to restart resin"
echo "#################################################################"
