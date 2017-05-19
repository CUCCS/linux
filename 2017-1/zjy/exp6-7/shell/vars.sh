#!/bin/bash
# ssh
ip="192.168.63.4"
username="root"
password="111"
keypath="/root/.ssh/id_rsa.pub"


# FTP 
WHITE_IP="192.168.63.16"
FTP_USER="virtual"
FTP_PASS="password"


# Samba
CLIENT_IP="192.168.63.16"
SMB_USER="demoUser"
SMB_PASS="password"
SMB_GROUP="demoGroup"


# DHCP
DHCP_INTERFACE="enp0s3"
INTERFACE_ADDRESS="10.0.2.18"
SUBNET="10.0.2.0"
SUB_DOWN="10.0.2.20"
SUB_TOP="10.0.2.100"
SUB_BROADCAST="10.0.2.255"
