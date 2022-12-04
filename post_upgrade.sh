#!/bin/sh

VERSION=$(curl -Ls http://www.ui.com/downloads/unifi/debian/dists/stable/ubiquiti/binary-amd64/Packages.gz | zcat | grep Version: | grep -Eo '[0-9\.]+' | head -n 1)
OLDVERSION=$(grep -o 'PORTVERSION=.*' /usr/ports/net-mgmt/unifi7/Makefile | awk -F = '{print $2}')

if [ "$VERSION" = "" ]; then
        exit 1
fi

if [ "$VERSION" = "$OLDVERSION" ]; then
	echo "Already up to date: $VERSION"
	exit 0
fi

pkg unlock -y unifi7
service unifi stop

portsnap fetch 2>&1 | grep -v '^/usr/ports'
portsnap extract
cd /usr/ports/net-mgmt/unifi7/
export ALLOW_UNSUPPORTED_SYSTEM=1
sed -i '' "s/^PORTVERSION=.*/PORTVERSION=$VERSION/g" Makefile
sed -i '' 's/^.error.*do not agree on major.*//g' /usr/ports/Mk/bsd.port.mk
rm -rf /usr/ports/distfiles/unifi*
make makesum || exit 1
make deinstall
make install
make clean

service unifi start
pkg lock -y unifi7
