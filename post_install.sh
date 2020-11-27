#!/bin/sh

curl -Lo /root/post_upgrade.sh https://github.com/mkuron/iocage-plugin-unificontroller-latest/raw/master/post_upgrade.sh
chmod +x /root/post_upgrade.sh

VERSION=$(curl -Ls http://www.ui.com/downloads/unifi/debian/dists/stable/ubiquiti/binary-amd64/Packages.gz | zcat | grep Version: | grep -Eo '[0-9\.]+' | head -n 1)

portsnap fetch
portsnap extract
export ALLOW_UNSUPPORTED_SYSTEM=1

cd /usr/ports/ports-mgmt/pkg
make deinstall
make reinstall

cd /usr/ports/net-mgmt/unifi5/
sed -i '' "s/^PORTVERSION=.*/PORTVERSION=$VERSION/g" Makefile
make makesum
make install
make clean

pkg lock -y unifi5

sysrc -f /etc/rc.conf unifi_enable="YES"
sysrc -f /etc/rc.conf cron_enable="NO"
