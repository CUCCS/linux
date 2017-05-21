#!/bin/bash
source vars.sh


echo $DHCP_INTERFACE;

#ftp  

path=/home/${FTP_USER}


if [[ ! -d "/usr/local/etc/vsftpd" ]] ; then 
   mkdir /usr/local/etc/vsftpd
fi

echo -e "input the password of ftp user:"

/usr/bin/expect << EOF
spawn ftpasswd --passwd --file=/usr/local/etc/vsftpd/passwd --name=${FTP_USER} --uid=1024 --home=/home/${FTP_USER} --shell=/bin/false
expect {
 "Password:" {send "${FTP_PASS}\r"; exp_continue}
 "Re-type password:" {send "${FTP_PASS}\r";}
}
expect eof
EOF


ftpasswd --file=/usr/local/etc/vsftpd/group --group --name=virtualusers --gid=1024

ftpasswd --group --name=virtualusers --gid=1024 --member=${FTP_USER} --file=/usr/local/etc/vsftpd/group

if [[ ! -d "$path" ]] ; then
   mkdir  -p $path
   chown -R 1024:1024 $path
   chmod -R 700 $path

fi

service vsftpd restart

#NFS


path=/var/nfs/general

if [[ ! -d "$path" ]] ; then 

  mkdir  -p $path
fi

chown nobody:nogroup $path

service nfs-kernel-server restart

#samba

useradd -M -s /sbin/nologin ${SMB_USER}

echo -e  "input the ${SMB_USER}"

/usr/bin/expect << EOF
spawn passwd ${SMB_USER}
expect {
 "Enter new UNIX password:" {send "${SMB_PASS}\r"; exp_continue}
 "Retype new UNIX password:" {send "${SMB_PASS}\r";}
}
expect eof
EOF



/usr/bin/expect << EOF
spawn smbpasswd -a ${SMB_USER}
expect {
 "New SMB password:" {send "${SMB_PASS}\r"; exp_continue}
 "Retype new SMB password:" {send "${SMB_PASS}\r";}
}
expect eof
EOF

smbpasswd -e ${SMB_USER}

groupadd ${SMB_GROUP}

usermod -G ${SMB_GROUP} ${SMB_USER}



if [[ ! -d "/srv/samba/guest/" ]] ; then

  mkdir  -p /srv/samba/guest/
fi


if [[ ! -d "/srv/samba/demo/" ]] ; then
  mkdir  -p /srv/samba/demo/
fi

chgrp -R ${SMB_GROUP} /srv/samba/guest/
chgrp -R ${SMB_GROUP} /srv/samba/demo/

chmod 2775 /srv/samba/guest/
chmod 2770 /srv/samba/demo/

smbd


#DHCP


ifconfig ${DHCP_INTERFACE} up

ifconfig ${DHCP_INTERFACE} ${INTERFACE_ADDRESS} netmask 255.255.255.0


service isc-dhcp-server restart

#DNS

service bind9 restart
