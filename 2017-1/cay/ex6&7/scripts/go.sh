#!/bin/bash
source set-vars.sh

expect auto-ssh.sh $username $ip $password

ssh $username@$ip -C "/bin/bash" < pre-install.sh

sed -i "s/WHITE_IP/${WHITE_IP}/g" /home/configs/proftpd.conf
sed -i "s/CLIENT_IP/${CLIENT_IP}/g" /home/configs/exports
sed -i "s/SMB_USER/${SMB_USER}/g" /home/configs/smb.conf
sed -i "s/SMB_GROUP/${SMB_GROUP}/g" /home/configs/smb.conf
sed -i "s/DHCP_INTERFACE/${DHCP_INTERFACE}/g" /home/configs/isc-dhcp-server
sed -i "s/SUBNET/${SUBNET}/g" /home/configs/dhcpd.conf
sed -i "s/SUB_DOWN/${SUB_DOWN}/g" /home/configs/dhcpd.conf
sed -i "s/SUB_TOP/${SUB_TOP}/g" /home/configs/dhcpd.conf
sed -i "s/SUB_BROADCAST/${SUB_BROADCAST}/g" /home/configs/dhcpd.conf
sed -i "s/INTERFACE_ADDRESS/${INTERFACE_ADDRESS}/g" /home/configs/db.cuc.edu.cn

sshpass -p $password scp /home/configs/proftpd.conf $username@$ip:/etc/proftpd/
sshpass -p $password scp /home/configs/exports $username@$ip:/etc/
sshpass -p $password scp /home/configs/smb.conf $username@$ip:/etc/samba/
sshpass -p $password scp /home/configs/isc-dhcp-server $username@$ip:/etc/default/
sshpass -p $password scp /home/configs/dhcpd.conf $username@$ip:/etc/dhcp/
sshpass -p $password scp /home/configs/db.cuc.edu.cn $username@$ip:/etc/bind/
sshpass -p $password scp set-vars.sh $username@$ip:
ssh $username@$ip -C 'bash -s' < config.sh

