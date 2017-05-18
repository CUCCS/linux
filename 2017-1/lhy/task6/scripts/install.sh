#!/bin/bash
source /root/set-var.sh
# update & install
apt-get update
if [ $? -ne 0 ] ; then
  echo "Error : Fail to update"
  exit 0
else
apt-get install debconf-utils
if [ $? -ne 0 ] ; then
  echo "Error : Fail to install the packages"
  exit 0
else
debconf-set-selections <<\EOF
proftpd-basic shared/proftpd/inetd_or_standalone select standalone 
EOF
  apt-get install -y  proftpd nfs-kernel-server samba isc-dhcp-server bind9 expect
  if [ $? -ne 0 ] ; then
    echo "Error : Fail to install the packages"
    exit 0
  fi
fi
fi

# copy the configuration files
# FTP:proftpd
cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bak
# NFS
cp /etc/exports /etc/exports.bak
# samba
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
# DHCP
cp /etc/network/interfaces  /etc/network/interfaces.bak
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
# DNS:bind9
cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak


