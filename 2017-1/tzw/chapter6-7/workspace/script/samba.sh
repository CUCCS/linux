source ./script/global_conf.sh
# samba install
apt-get install samba -y
echo "samba-server installed"
apt-get install smbclient -y
echo "samba-client installed"

# Create samba user
useradd -M -s /usr/sbin/nologin $server_samba_name
./script/create_user.sh $server_samba_name $server_samba_pwd > /dev/null
echo "New user $server_samba_name added"

# Create samba group
groupadd sambaGroup
usermod -G sambaGroup sambauser

# Backup the original conf
mv /etc/samba/smb.conf $server_samba_bak/smb_conf.bak
echo "Backup conf finished"

# Add the new conf
cp $server_samba_conf/smb.conf /etc/samba/smb.conf
echo "Add new conf finished"

echo "SAMBA PART FINISHED"
