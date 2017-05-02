#!/usr/bin/expect  
function auto_smart_ssh
{
systemuser=$(whoami)
sshkey="/home/$systemuser/.ssh/id_rsa"
if [ ! -f "$sshkey" ]; then
    ssh-keygen -t rsa -P "" -f $sshkey
fi
username=$1
password=$2
hostname=$3
expect -c "
set timeout 10  
spawn ssh-copy-id -i /home/$systemuser/.ssh/id_rsa.pub $username@$hostname
expect {
            \"Are you sure you want to continue connecting (yes/no)?\" {
            send \"yes\r\"
            expect \"password*\"
                send \"$password\r\"
            exp_continue
            }
            \"password*\" { 
                send \"$password\r\"
                exp_continue
            }
            \"Now try logging into the machine\" {
            exp_continue
            }
    expect eof
        }
"
ssh $username@$hostname <<remotessh

echo '$password' |sudo -S apt-get update
if [$? -ne 0 ];then
    echo "Sorry,update failed,please check your network~~~"
    exit 1
fi
echo '$password' |sudo -S apt-get install expect --assume-yes

expect -c "
set timeout 10  
spawn sudo mkdir /root/.ssh
expect {
    \"password*\"
    {
        send \"$password\r\"
        exp_continue
    }
expect eof
}
"
expect -c "
set timeout 10  
spawn sudo cp /home/cuc/.ssh/authorized_keys /root/.ssh/authorized_keys
expect {
     \"password*\"
     {
        send \"$password\r\"
        exp_continue
     }
expect eof
}
"
exit
remotessh
ssh root@$hostname<<remotessh
exit
remotessh
}
function set_ftp
{
#install vsftpd
username=$1
hostname=$2
password=$3
ssh root@$hostname<<remotessh
mkdir workspace
apt-get install vsftpd --assume-yes
exit
remotessh

#copy conf files
nowposi=$(pwd -P)
scp -r $nowposi/conf root@$hostname:/root/workspace

#set vsftpd
ssh root@$hostname<<remotessh
cp /etc/vsftpd.conf /etc/vsftpd.conf.back
cp /root/workspace/conf/vsftpd.conf /etc/vsftpd.conf

cp /etc/vsftpd.userlist /etc/vsftpd.userlist.back
cp /root/workspace/conf/vsftpd.userlist /etc/vsftpd.userlist

cp /etc/hosts.allow /etc/hosts.allow.back
cp /root/workspace/conf/hosts.allow /etc/hosts.allow

cp /etc/hosts.deny /etc/hosts.deng.back
cp /root/workspace/conf/hosts.deny /etc/hosts.deny

useradd -s /usr/sbin/nologin $username
expect -c "
set timeout 10  
spawn passwd $username
expect {
    \"*password*\"
    {
        send \"$password\r\"
        expect {
            \"*password*\"
            {
                send \"$password\r\"
                expect {
                    \"*password*\"
                    {
                        send \"$password\r\"

        expect {
            \"*password*\"
            {
                send \"$password\r\"
        expect {
            \"*password*\"
            {
                send \"$password\r\"
        expect {
            \"*password*\"
            {
                send \"$password\r\"
        expect {
            \"*password*\"
            {
                send \"$password\r\"
            }
        }
            }
        }
            }
        }
            }
        }
                    }
                }
            }
        }
    }
expect eof
}
"
chown $username:$username /home/$username/
mkdir -p /home/$username/ftp
mkdir -p /var/ftp
chown $username:$username /home/$username/ftp
chown nobody:nogroup /home/$username/ftp
mkdir /home/$username/ftp/files
chown $username:$username /home/$username/ftp/files




expect -c "
set timeout 10  
spawn openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
expect {
    \"*Name*\"
    {
        send \"\r\"
        expect {
            \"*Name*\"
            {
                send \"\r\"
        expect {
            \"*Name*\"
            {
                send \"\r\"
        expect {
            \"*Name*\"
            {
                send \"\r\"
        expect {
            \"*Name*\"
            {
                send \"\r\"
        expect {
            \"*Name*\"
            {
                send \"\r\"
        expect {
            \"*Name*\"
            {
                send \"\r\"
        expect {
            \"*Name*\"
            {
                send \"\r\"
            }}}}}}}}}}}}}}}
expect eof
}
"
service vsftpd restart
exit
remotessh
}
function set_nfs
{
username=$1
hostname=$2
ssh root@$hostname<<remotessh
apt-get install nfs-kernel-server --assume-yes
cp /etc/exports /etc/exports.back
cp /root/workspace/conf/exports /etc/exports

mkdir /home/$username/nfs/
mkdir /home/$username/nfs1/

systemctl restart nfs-kernel-server.service
exit
remotessh
}
function set_samba
{
username=$1
hostname=$2
password=$3
ssh root@$hostname<<remotessh

cp /etc/samba/smb.conf /etc/samba/smb.conf.back
cp /root/workspace/conf/smb.conf /etc/samba/smb.conf

apt-get install samba --assume-yes
useradd -M -s /sbin/nologin $username
expect -c "
set timeout 10  
spawn passwd $username
expect {
    \"*password*\"
    {
        send \"$password\r\"
        expect \"*password*\"
            send \"$password\r\"
    }
expect eof
}
"
expect -c "
set timeout 10  
spawn smbpasswd -a $username
expect {
    \"*password*\"
    {
        send \"$password\r\"
        expect \"*password*\"
            send \"$password\r\"
    }
expect eof
}
"
smbpasswd -e $username
groupadd demoGroup
usermod -G demoGroup $username
mkdir -p /srv/samba/guest/
mkdir -p /srv/samba/demo/
chgrp -R demoGroup /srv/samba/guest/
chgrp -R demoGroup /srv/samba/demo/

chmod 2775 /srv/samba/guest/
chmod 2770 /srv/samba/demo/
systemctl restart smbd.service 
exit
remotessh
}
function set_dhcp
{
networkcard=$1
ssh root@$hostname<<remotessh
apt-get install isc-dhcp-server --assume-yes

cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.back
sed -i '/^INTERFACES/d' /etc/default/isc-dhcp-server

cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.back
cp /root/workspace/conf/dhcpd.conf /etc/dhcp/dhcpd.conf

echo INTERFACES=\"$networkcard\">>/etc/default/isc-dhcp-server
ifconfig $networkcard up
ifconfig $networkcard 10.0.66.1 netmask 255.255.255.0
systemctl restart isc-dhcp-server.service
exit
remotessh
}
function set_dns
{

ssh root@$hostname<<remotessh
apt-get install bind9 bind9utils bind9-doc --assume-yes
sed -i '/^OPTIONS/d' /etc/default/bind9
echo OPTIONS="-4 -u bind">>/etc/default/bind9

cp /etc/bind/named.conf.options /etc/bind/named.conf.options.back
cp /root/workspace/conf/named.conf.options /etc/bind/named.conf.options

cp /etc/bind/named.conf.local /etc/bind/named.conf.local.back
cp /root/workspace/conf/named.conf.local /etc/bind/named.conf.local

mkdir -p /etc/bind/zones
cp /root/workspace/conf/db.cuc.edu.cn /etc/bind/zones/db.cuc.edu.cn
systemctl restart bind9.service
exit
remotessh
}
source config.conf
auto_smart_ssh $hostuser $password $hostname
set_ftp $ftpnfsuser $hostname $ftppassword
set_nfs $ftpnfsuser $hostname
set_samba $sambaname $hostname $sambapassword
set_dhcp networkcard
set_dns

