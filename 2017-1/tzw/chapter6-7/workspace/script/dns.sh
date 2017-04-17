source script/global_conf.sh

# band9 install
apt install bind9 -y
apt install dnsutils -y
echo "bind9 installed"

# Backup the original conf
mv /etc/bind/named.conf.options $server_dns_bak/named.conf.options
mv /etc/bind/named.conf.local $server_dns
echo "Backup conf finished"

# Add the new conf
cp $server_dns_conf/dns/named.conf.options /etc/bind/named.conf.options
cp $server_dns_conf/dns/named.conf.local /etc/bind/named.conf.local
cp $server_dns_conf/dns/db.cuc.edu.cn /etc/bind/db.cuc.edu.cn
echo "New conf added"

echo "DNS PART FINISHED"
