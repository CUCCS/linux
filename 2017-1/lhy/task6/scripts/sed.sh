#!/bin/bash
source  set-var.sh

# use sed to change the configurations
sed -i "s/PRO_WHITE_IP/${PRO_WHITE_IP}/g" conf/proftpd.conf
sed -i "s/NFS_CLIENT_IP/${NFS_CLIENT_IP}/g" conf/exports
sed -i "s/SAMBA_USERNAME/${SAMBA_USERNAME}/g" conf/smb.conf
sed -i "s/SAMBA_GROUP/${SAMBA_GROUP}/g" conf/smb.conf
sed -i "s/HOST_ONLY_INTER/${HOST_ONLY_INTER}/g" conf/interfaces
sed -i "s/NAT_INTER/${NAT_INTER}/g" conf/interfaces
sed -i "s/INTERNAL_INTER/${INTERNAL_INTER}/g" conf/interfaces
sed -i "s/INTERNAL_IP/${INTERNAL_IP}/g" conf/interfaces
sed -i "s/INTERNAL_NETMASK/${INTERNAL_NETMASK}/g" conf/interfaces
sed -i "s/INTERNAL_INTER/${INTERNAL_INTER}/g" conf/isc-dhcp-server
sed -i "s/SUBNET_SUB/${SUBNET_SUB}/g" conf/dhcpd.conf
sed -i "s/SUBNET_BOTTOM/${SUBNET_BOTTOM}/g" conf/dhcpd.conf
sed -i "s/SUBNET_TOP/${SUBNET_TOP}/g" conf/dhcpd.conf
sed -i "s/SUBNET_BROADCAST/${SUBNET_BROADCAST}/g" conf/dhcpd.conf
sed -i "s/INTERNAL_NETMASK/${INTERNAL_NETMASK}/g" conf/dhcpd.conf
sed -i "s/INTERNAL_IP/${INTERNAL_IP}/g" conf/db.cuc.edu.cn

