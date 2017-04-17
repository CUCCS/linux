source script/global_conf.sh
rm -rf conf/*
cp -r conf_origin/* conf
# CHANGE_FTP_CONF
sed 's/client_ip_mark/'$server_internal_ip'/g' conf_origin/ftp/hosts.allow > conf/ftp/hosts.allow
sed 's/ftp_name_mark/'$server_ftp_name'/g' conf_origin/ftp/vsftpd.userlist > conf/ftp/vsftpd.userlist

# CHANGE_DHCP_CONF
mkdir conf/dhcp/temp
sed 's/dhcp_net_address/'$dhcp_net_address'/g' conf_origin/dhcp/dhcpd.conf > conf/dhcp/temp/dhcpd.conf.a
sed 's/dhcp_net_netmask/'$dhcp_net_netmask'/g' conf/dhcp/temp/dhcpd.conf.a > conf/dhcp/temp/dhcpd.conf.b
sed 's/dhcp_net_start/'$dhcp_net_start'/g' conf/dhcp/temp/dhcpd.conf.b > conf/dhcp/temp/dhcpd.conf.c
sed 's/dhcp_net_end/'$dhcp_net_end'/g' conf/dhcp/temp/dhcpd.conf.c > conf/dhcp/temp/dhcpd.conf.d
sed 's/dhcp_broad/'$dhcp_broad'/g' conf/dhcp/temp/dhcpd.conf.d > conf/dhcp/dhcpd.conf
rm -rf conf/dhcp/temp
sed 's/server_net_interface/'$server_net_interface'/g' conf_origin/dhcp/isc-dhcp-server > conf/dhcp/isc-dhcp-server

# CHANGE_DNS_CONF
sed 's/client_ip_mark/'$client_internal_ip'/g' conf_origin/dns/named.conf.options > conf/dns/named.conf.options

# CHANGE_NFS_CONF
sed 's/client_ip_mark/'$client_internal_ip'/g' conf_origin/nfs/exports > conf/nfs/exports

# CHANGE_SAMBA_CONF
mkdir conf/samba/temp
sed 's/server_samba_name/'$server_samba_name'/g' conf_origin/samba/smb.conf > conf/samba/temp/smb_conf.a
sed 's/server_samba_group/'$server_samba_group'/g' conf/samba/temp/smb_conf.a > conf/samba/smb.conf
rm -rf conf/samba/temp
