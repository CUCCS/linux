source ./script/global_conf.sh

# vsftpd install
apt-get install vsftpd -y
ret=$? && [[ $ret -eq 0 ]] || {
	echo "vsftpd server installed with ret code $ret"
	exit $ret
}
# Backup the original conf
if [ ! -f "/etc/vsftpd.conf" -o ! -f "/etc/hosts.allow" -o ! -f "/etc/hosts.deny" -o ! -f "/etc/shells" ]; then
	echo "(ftp)some original conf file no exist"
	exit $ERROR_CODE
else
  mv "/etc/vsftpd.conf" "$server_ftp_bak/vsftpd_conf.bak"
  mv "/etc/hosts.allow" "$server_ftp_bak/hosts_allow.bak"
  mv "/etc/hosts.deny" "$server_ftp_bak/hosts_deny.bak"
  mv "/etc/shells" "$server_ftp_bak/shells.bak"
fi

# Add the new conf
if [ ! -f "$server_ftp_conf/vsftpd.conf" -o ! -f "$server_ftp_conf/hosts.allow" -o ! -f "$server_ftp_conf/hosts.deny" -o ! -f "$server_ftp_conf/shells" -o ! -f "$server_ftp_conf/vsftpd.userlist" ];then
        echo "(ftp)some new conf file no exist"
        exit $ERROR_CODE
else
  cp "$server_ftp_conf/vsftpd.conf" "/etc/vsftpd.conf"
  cp "$server_ftp_conf/hosts.allow" "/etc/hosts.allow"
  cp "$server_ftp_conf/hosts.deny" "/etc/hosts.deny"
  cp "$server_ftp_conf/shells" "/etc/shells"
  cp "$server_ftp_conf/vsftpd.userlist" "/etc/vsftpd.userlist"
fi

# Add a ftp user
useradd $server_ftp_name
ret=$? && [[ $ret -eq 0 ]] || {
	echo "(ftp)FTP user add with ret code $ret"
	exit $ret
}
script/change_user_passwd.sh $server_ftp_name $server_ftp_pwd >  /dev/null
ret=$? && [[ $ret -eq 0 ]] || {
	echo "(ftp)Change user password error with ret code $ret"
	exit $ret
}

# Create ftp jail
[[ -d "/home/$server_ftp_name" ]] || {
	mkdir "/home/$server_ftp_name"
}
[[ -d "/home/$server_ftp_name/ftp" ]] || {
        mkdir "/home/$server_ftp_name/ftp"
}

chown nobody:nogroup /home/$server_ftp_name/ftp
ret=$? && [[ $ret -eq 0 ]] || {
	echo "(ftp)chown nobody:nogroup /home/$server_ftp_name/ftp error with ret code $ret"
	exit $ret
}

chmod a-w /home/$server_ftp_name/ftp
ret=$? && [[ $ret -eq 0 ]] || {
	echo "(ftp)chmod a-w /home/$server_ftp_name error with ret code $ret"
	exit $ret
}
# Create ftp jail with user ownership
[[ -d "/home/$server_ftp_name/ftp/files" ]] || {
	mkdir "/home/$server_ftp_name/ftp/files"
}
chown $server_ftp_name:$server_ftp_name /home/$server_ftp_name/ftp/files
ret=$? && [[ $ret -eq 0 ]] || {
	echo "(ftp)chown $server_ftp_name:$server_ftp_name /home/$server_ftp_name/ftp/files with ret code $ret"
	exit $ret
}
tee /home/$server_ftp_name/ftp/files/test.txt
ret=$? && [[ $ret -eq 0 ]] || {
	echo "(ftp)tee /home/$server_ftp_name/ftp/files/test.txt with ret code $ret"
	exit $ret
}

# Ban shell access
usermod -s /usr/sbin/nologin $server_ftp_name
ret=$? && [[ $ret -eq 0 ]] || {
	echo "(ftp)usermod -s /usr/sbin/nologin $server_ftp_name error with ret code $ret"
	exit $ret
}

