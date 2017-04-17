# Set IP 
server_hostonly_ip=192.168.112.20
server_internal_ip=100.0.0.1

client_internal_ip=100.0.0.100

dhcp_net_address=100.0.0.0
dhcp_net_start=100.0.0.100
dhcp_net_end=100.0.0.200
dhcp_broad=100.0.0.255
dhcp_net_netmask=255.255.255.0

# Set port
server_ssh_port=22
server_ftp_port=20

# Set names
server_root_name=root
server_ftp_name=ftpuser
server_samba_name=sambauser
server_samba_group=sambaGroup

# Set interface
server_net_interface=enp0s9

# Set password
server_ssh_pwd=123
server_ftp_pwd=123
server_samba_pwd=123

# Set path
self_root_ssh_key=/root/.ssh/id_rsa.pub
server_root_path=/root

server_ftp_conf=./conf/ftp
server_ftp_bak=./bak/ftp

server_nfs_conf=./conf/nfs
server_nfs_bak=./bak/nfs

server_dhcp_conf=./conf/dhcp
server_dhcp_bak=./bak/dhcp

server_samba_conf=./conf/samba
server_samba_bak=./bak/samba

server_dns_conf=./conf/dns
server_dns_bak=./bak/dns
