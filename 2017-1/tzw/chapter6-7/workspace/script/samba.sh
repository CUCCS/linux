source ./script/global_conf.sh
# samba install
apt-get install samba -y
ret=$? && [[ $ret -eq 0 ]] || {
	echo "SAMBA server installed with ret code $ret"
	exit $ret
}

# Create samba user
useradd -M -s /usr/sbin/nologin $server_samba_name
ret=$? && [[ $ret -eq 0 ]] || {
        echo "(samba)SAMBA user add with ret code $ret"
        exit $ret
}

./script/change_user_passwd.sh $server_samba_name $server_samba_pwd > /dev/null
ret=$? && [[ $ret -eq 0 ]] || {
        echo "(samba)Change user password error with ret code $ret"
        exit $ret
}

# Create samba group
groupadd sambaGroup
ret=$? && [[ $ret -eq 0 ]] || {
        echo "(samba)groupadd sambaGroup error with ret code $ret"
        exit $ret
}

usermod -G sambaGroup sambauser
ret=$? && [[ $ret -eq 0 ]] || {
        echo "(samba)usermod -G sambaGroup sambauser error with ret code $ret"
        exit $ret
}

# Backup the original conf
if [ ! -f "/etc/samba/smb.conf" ]; then
  echo "(samba)original conf file does not exist"
  exit $ERROR_CODE
else
  mv "/etc/samba/smb.conf" "$server_samba_bak/smb_conf.bak"
fi
# Add the new conf
cp "$server_samba_conf/smb.conf" "/etc/samba/smb.conf"

