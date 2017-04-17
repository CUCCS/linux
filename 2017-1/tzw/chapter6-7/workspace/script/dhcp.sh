source ./script/global_conf.sh

# dhcp-server install
apt install isc-dhcp-server -y
echo "dhcp-server installed"

# Backup the original conf
mv /etc/default/isc-dhcp-server $server_dhcp_bak/isc-dhcp-server.bak
mv /etc/dhcp/dhcpd.conf $server_dhcp_bak/dhcpd_conf.bak
echo "Backup conf finished"

# Add the new conf
cp $server_dhcp_conf/isc-dhcp-server /etc/default/isc-dhcp-server
cp $server_dhcp_conf/dhcpd.conf /etc/dhcp/dhcpd.conf
echo "New conf added"

echo "DHCP PART FINISH"
