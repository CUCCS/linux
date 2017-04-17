source ./script/global_conf.sh

# vsftpd install
apt-get install vsftpd -y
echo "vsftpd installed"

# Backup the original conf
mv /etc/vsftpd.conf $server_ftp_bak/vsftpd_conf.bak
mv /etc/hosts.allow $server_ftp_bak/hosts_allow.bak
mv /etc/hosts.deny $server_ftp_bak/hosts_deny.bak
mv /etc/shells $server_ftp_bak/shells.bak
echo "Backup conf finished"

# Add the new conf
cp $server_ftp_conf/vsftpd.conf /etc/vsftpd.conf
cp $server_ftp_conf/hosts.allow /etc/hosts.allow
cp $server_ftp_conf/hosts.deny /etc/hosts.deny
cp $server_ftp_conf/shells /etc/shells
cp $server_ftp_conf/vsftpd.userlist /etc/vsftpd.userlist
echo "New conf added"

# Add a ftp user
useradd $server_ftp_name
./script/create_user.sh $server_ftp_name $server_ftp_pwd >  /dev/null
echo "New user $server_ftp_name added"

# Create ftp jail
mkdir /home/$server_ftp_name
mkdir /home/$server_ftp_name/ftp
chown nobody:nogroup /home/$server_ftp_name/ftp
chmod a-w /home/$server_ftp_name/ftp
echo "Create ftp jail finished"

# Create ftp jail with user ownership
mkdir /home/$server_ftp_name/ftp/files
chown $server_ftp_name:$server_ftp_name /home/$server_ftp_name/ftp/files
tee /home/$server_ftp_name/ftp/files/test.txt

# Ban shell access
usermod -s /usr/sbin/nologin $server_ftp_name
echo "Ban shell access finished"


echo "FTP PART FINISH"
