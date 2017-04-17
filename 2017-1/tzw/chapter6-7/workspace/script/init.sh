# create directory
mkdir bak
mkdir bak/ftp
mkdir bak/nfs
mkdir bak/dhcp
mkdir bak/samba
mkdir bal/dns

# apt action
./script/apt.sh

# ftp server action
./script/ftp.sh

# nfs server action
./script/nfs.sh

# dhcp server action
./script/dhcp.sh

# samba server action
./script/samba.sh

# DNS server action
./script/dns.sh
