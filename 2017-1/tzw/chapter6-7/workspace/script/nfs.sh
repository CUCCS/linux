# nfs-server install
source ./script/global_conf.sh
apt-get install nfs-kernel-server -y
echo "NFS server installed"

# Backup the original conf
mv /etc/exports $server_nfs_bak/exports.bak
echo "Backup conf finished"

# Add the new conf
cp $server_nfs_conf/exports /etc/exports
echo "New conf added"

echo "NFS PART FINISHED"
