#!/bin/bash

source vars.sh

rm /root/.ssh/known_hosts

expect ssh-root.sh $ip $username $password ${keypath}

ssh $username@$ip 'bash -s' < apt-ins.sh

#exit 0

sed -i "s/WHITE_IP/${WHITE_IP}/g" /root/configs/proftpd.conf

sed -i "s/CLIENT_IP/${CLIENT_IP}/g" /root/configs/exports

sed -i "s/SMB_USER/${SMB_USER}/g" /root/configs/smb.conf
sed -i "s/SMB_GROUP/${SMB_GROUP}/g" /root/configs/smb.conf

sed -i "s/DHCP_INTERFACE/${DHCP_INTERFACE}/g" /root/configs/isc-dhcp-server

sed -i "s/SUBNET/${SUBNET}/g" /root/configs/dhcpd.conf
sed -i "s/SUB_DOWN/${SUB_DOWN}/g" /root/configs/dhcpd.conf
sed -i "s/SUB_TOP/${SUB_TOP}/g" /root/configs/dhcpd.conf
sed -i "s/SUB_BROADCAST/${SUB_BROADCAST}/g" /root/configs/dhcpd.conf

sed -i "s/INTERFACE_ADDRESS/${INTERFACE_ADDRESS}/g" /root/configs/db.cuc.edu.cn


scp /root/configs/proftpd.conf $username@$ip:/etc/proftpd/
scp /root/configs/exports  $username@$ip:/etc/
scp /root/configs/smb.conf $username@$ip:/etc/samba/
scp /root/configs/isc-dhcp-server $username@$ip:/etc/default/
scp /root/configs/dhcpd.conf $username@$ip:/etc/dhcp/
scp /root/configs/db.cuc.edu.cn $username@$ip:/etc/bind/
scp vars.sh $username@$ip:


ssh $username@$ip 'bash -s' < action.sh
