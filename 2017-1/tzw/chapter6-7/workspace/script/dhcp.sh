source ./script/global_conf.sh

# dhcp-server install
apt install isc-dhcp-server -y
ret=$? && [[ $ret -eq 0 ]] || {
	echo "DHCP server installed with ret code $ret"
}

# Backup the original conf
if [ ! -f "/etc/default/isc-dhcp-server" -o ! -f "/etc/dhcp/dhcpd.conf" ]; then
  echo "(dhcp)original conf file does not exist"
  exit $ERROR_CODE
else
  mv "/etc/default/isc-dhcp-server" "$server_dhcp_bak/isc-dhcp-server.bak"
  mv "/etc/dhcp/dhcpd.conf" "$server_dhcp_bak/dhcpd_conf.bak"
fi

# Add the new conf
if [ ! -f "$server_dhcp_conf/isc-dhcp-server" -o ! -f "$server_dhcp_conf/dhcpd.conf" ]; then
  echo "(dhcp)new conf file does not exist"
  exit $ERROR_CODE
else
  cp "$server_dhcp_conf/isc-dhcp-server" "/etc/default/isc-dhcp-server"
  cp "$server_dhcp_conf/dhcpd.conf" "/etc/dhcp/dhcpd.conf"
fi
