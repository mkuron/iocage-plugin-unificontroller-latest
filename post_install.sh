#!/bin/sh

# TODO: get automatically
VERSION=5.10.21

portsnap fetch
portsnap extract
cd /usr/ports/net-mgmt/unifi5/
sed -i '' "s/^PORTVERSION=.*/PORTVERSION=$VERSION/g" Makefile
make makesum
make install
make clean

sysrc -f /etc/rc.conf unifi_enable="YES"
service unifi start 2>/dev/null
