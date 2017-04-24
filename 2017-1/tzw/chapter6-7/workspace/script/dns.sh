source script/global_conf.sh

# band9 install
apt install bind9 -y
ret=$? && [[ $ret -eq 0 ]] || {
	echo "DNS server installed with ret code $ret"
	exit $ret
}

# Backup the original conf
if [ ! -f "/etc/bind/named.conf.options" -o ! -f "/etc/bind/named.conf.local" ]; then
  echo "(dns)original file does not exist"
  exit $ERROR_CODE
else
  mv "/etc/bind/named.conf.options" "$server_dns_bak/named.conf.options"
  mv "/etc/bind/named.conf.local" "$server_dns_bak/named.conf.local"
fi

# Add the new conf
if [ ! -f "$server_dns_conf/named.conf.options" -o ! -f "$server_dns_conf/named.conf.local" -o ! -f "$server_dns_conf/db.cuc.edu.cn" ]; then
  echo "(dns)new file does not exist"
else
  cp "$server_dns_conf/named.conf.options" "/etc/bind/named.conf.options"
  cp "$server_dns_conf/named.conf.local" "/etc/bind/named.conf.local"
  cp "$server_dns_conf/db.cuc.edu.cn" "/etc/bind/db.cuc.edu.cn"
fi
