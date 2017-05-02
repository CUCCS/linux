#!/bin/bash

source /root/global-var.sh

# FTP:proftpd

if [ ! -d "$PRO_DIR" ] ; then
  mkdir $PRO_DIR
fi
chown -R ftp:nogroup $PRO_DIR
usermod -d $PRO_DIR ftp

if [ ! -d "$PRO_VIR_DIR" ] ; then
  mkdir $PRO_VIR_DIR
fi
chown -R $PRO_UID:$PRO_GID $PRO_VIR_DIR
chmod -R $PRO_LIMIT $PRO_VIR_DIR

if [ ! -d "$PRO_FTPASSWD_DIR" ] ; then
  mkdir $PRO_FTPASSWD_DIR
fi

/usr/bin/expect << EOF
spawn ftpasswd --passwd --file=$PRO_PASSWD_DIR --name=$PRO_VIRTUAL_USER --uid=$PRO_UID --home=$PRO_VIR_DIR --shell=/bin/false
expect {
 "Password:" {send "${PRO_VIRTUAL_PASS}\r"; exp_continue}
 "Re-type password:" {send "${PRO_VIRTUAL_PASS}\r";}
}
expect eof
EOF
ftpasswd --file=$PRO_GROUP_DIR --group --name=$PRO_GROUP_NAME --gid=$PRO_GID
service proftpd restart


# NFS
NFS_GEN_DIR="/var/nfs/general"
NFS_HOME_DIR="/home"

if [ ! -d "$NFS_GEN_DIR" ] ; then
  mkdir $NFS_GEN_DIR -p
fi
chown nobody:nogroup $NFS_GEN_DIR
systemctl restart nfs-kernel-server


# samba
useradd -M -s /sbin/nologin $SAMBA_USERNAME
/usr/bin/expect << EOF
spawn passwd $SAMBA_USERNAME
expect {
 "*password:" {send "${SAMBA_PASSWORD}\r"; exp_continue}
 "*password:" {send "${SAMBA_PASSWORD}\r";}
}

spawn smbpasswd -a $SAMBA_USERNAME
expect {
 "*password:" {send "${SAMBA_PASSWORD}\r"; exp_continue}
 "*password:" {send "${SAMBA_PASSWORD}\r";}
}
EOF

smbpasswd -e $SAMBA_USERNAME
groupadd $SAMBA_GROUP
usermod -G $SAMBA_GROUP $SAMBA_USERNAME

mkdir -p $SAMBA_GUEST_DIR
mkdir -p $SAMBA_DEMO_DIR
chgrp -p $SAMBA_GROUP $SAMBA_GUEST_DIR
chgrp -R $SAMBA_GROUP $SAMBA_DEMO_DIR
chmod $SAMBA_GUEST_LIMIT $SAMBA_GUEST_DIR
chmod $SAMBA_DEMO_LIMIT $SAMBA_DEMO_DIR

smbd -s stop
smbd

# DHCP
service networking restart
service isc-dhcp-server restart

# DNS
systemctl restart bind9.service
