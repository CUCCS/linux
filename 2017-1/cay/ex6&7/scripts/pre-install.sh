#!/bin/bash
apt-get install cpufrequtils
expect say-yes.sh
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
# backup the original configs
cp /etc/network/interfaces /etc/network/interfaces.bak
cp /etc/proftpd/proftpd.conf  /etc/proftpd/proftpd.conf.bak
cp /etc/exports  /etc/exports.bak
cp /etc/samba/smb.conf  /etc/samba/smb.conf.bak
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak

exit
