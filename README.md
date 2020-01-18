# Install

```
git clone https://github.com/mkuron/iocage-plugin-unificontroller-latest.git unificontroller
cd unificontroller
iocage fetch -P -n unificontroller-latest.json ip4_addr="vnet0|192.168.200.21/24" bpf=yes vnet=on defaultrouter=192.168.200.1
iocage stop unificontroller
for d in conf data dl logs run work; do
  mkdir -p /CUSTOM/unifi/$d
  iocage fstab unificontroller -a "/CUSTOM/unifi/$d /usr/local/share/java/unifi/$d nullfs rw 0 0"
done
for d in log run; do
  mkdir -p /CUSTOM/unifi/var$d
  iocage fstab unificontroller -a "/CUSTOM/unifi/var$d /var/$d nullfs rw 0 0"
done
iocage exec unificontroller chown unifi /usr/local/share/java/unifi/{conf,data,logs,run,work}
iocage start unificontroller
```

# Update

```
iocage exec unificontroller pkg update
iocage exec unificontroller pkg upgrade --yes
iocage exec unificontroller /root/post_upgrade.sh
```

# Remove

All data is stored outside the jail, so configuration and database remain intact for later use.

```
iocage stop unificontroller
iocage destroy unificontroller
```