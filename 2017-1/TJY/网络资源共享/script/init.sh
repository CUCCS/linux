#!/bin/bash

source global-var.sh

KNOWN_HOSTS="/root/.ssh/known_hosts"
if [ ! -d "$KNOWN_HOSTS" ] ; then
  rm $KNOWN_HOSTS
fi
rm $KNOWN_HOSTS

bash sed-conf.sh
expect ssh-root.sh $ip $username $password ${keypath}

scp global-var.sh $username@$ip:

ssh $username@$ip 'bash -s' < apt-ins.sh

# FTP:proftpd
scp conf/proftpd.conf $username@$ip:/etc/proftpd/

# NFS
scp conf/exports $username@$ip:/etc/exports

# samba
scp conf/smb.conf $username@$ip:/etc/samba/smb.conf

# DHCP
scp conf/interfaces $username@$ip:/etc/network/interfaces
scp conf/isc-dhcp-server $username@$ip:/etc/default/isc-dhcp-server
scp conf/dhcpd.conf $username@$ip:/etc/dhcp/dhcpd.conf

# DNS
scp conf/db.cuc.edu.cn $username@$ip:/etc/bind/db.cuc.edu.cn
scp conf/named.conf.local $username@$ip:/etc/bind/named.conf.local

ssh $username@$ip 'bash -s' < do-conf.sh
