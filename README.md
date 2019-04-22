# Install

  git clone https://github.com/mkuron/iocage-plugin-unificontroller-latest.git unificontroller
  cd unificontroller
  iocage fetch -P -n unificontroller-latest.json ip4_addr="em1|192.168.200.24/24"
  for d in conf data dl logs run work; do
    mkdir -p /CUSTOM/unifi/$d
    iocage fstab unificontroller -a "/CUSTOM/unifi/$d /usr/local/share/java/unifi/$d nullfs rw 0 0"
  done
  for d in log run; do
    mkdir -p /CUSTOM/unifi/var$d
    iocage fstab unificontroller -a "/CUSTOM/unifi/var$d /var/$d nullfs rw 0 0"
  done

# Update

To do