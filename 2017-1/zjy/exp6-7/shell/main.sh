#!/bin/bash
source vars.sh

expect auto-ssh.sh $username $ip $password

ssh $username@$ip -C "/bin/bash" < install-soft.sh

sed -i "s/WHITE_IP/${WHITE_IP}/g" /ttwork/conf/vsftpd.conf
sed -i "s/CLIENT_IP/${CLIENT_IP}/g" /ttwork/conf/exports
sed -i "s/SMB_USER/${SMB_USER}/g" /ttwork/conf/smb.conf
sed -i "s/SMB_GROUP/${SMB_GROUP}/g" /ttwork/conf/smb.conf
sed -i "s/DHCP_INTERFACE/${DHCP_INTERFACE}/g" /ttwork/conf/isc-dhcp-server
sed -i "s/SUBNET/${SUBNET}/g" /ttwork/conf/dhcpd.conf
sed -i "s/SUB_DOWN/${SUB_DOWN}/g" /ttwork/conf/dhcpd.conf
sed -i "s/SUB_TOP/${SUB_TOP}/g" /ttwork/conf/dhcpd.conf
sed -i "s/SUB_BROADCAST/${SUB_BROADCAST}/g" /ttwork/conf/dhcpd.conf
sed -i "s/INTERFACE_ADDRESS/${INTERFACE_ADDRESS}/g" /ttwork/conf/db.cuc.edu.cn

sshpass -p $password scp /ttwork/conf/vsftpd.conf $username@$ip:/etc/vsftpd/
sshpass -p $password scp /ttwork/conf/exports $username@$ip:/etc/
sshpass -p $password scp /ttwork/conf/smb.conf $username@$ip:/etc/samba/
sshpass -p $password scp /ttwork/conf/isc-dhcp-server $username@$ip:/etc/default/
sshpass -p $password scp /ttwork/conf/dhcpd.conf $username@$ip:/etc/dhcp/
sshpass -p $password scp /ttwork/conf/db.cuc.edu.cn $username@$ip:/etc/bind/
sshpass -p $password scp vars.sh $username@$ip:


ssh $username@$ip -C 'bash -s' < todo.sh
