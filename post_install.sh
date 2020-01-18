#!/bin/sh

VERSION=$(curl -Ls http://www.ui.com/downloads/unifi/debian/dists/stable/ubiquiti/binary-amd64/Packages.gz | zcat | grep Version: | grep -Eo '[0-9\.]+' | head -n 1)

portsnap fetch
portsnap extract
cd /usr/ports/net-mgmt/unifi5/
export ALLOW_UNSUPPORTED_SYSTEM=1
sed -i '' "s/^PORTVERSION=.*/PORTVERSION=$VERSION/g" Makefile
make makesum
make install
make clean

pkg lock -y unifi5

sysrc -f /etc/rc.conf unifi_enable="YES"
sysrc -f /etc/rc.conf cron_enable="NO"
