# nfs-server install
source ./script/global_conf.sh
apt-get install nfs-kernel-server -y
ret=$? && [[ $ret -eq 0 ]] || {
	echo "NFS server installed with ret code $ret"
}

# Backup the original conf
if [ ! -f "/etc/exports" ]; then
  echo "(nfs)original file /etc/exports does not exist"
  exit $ERROR_CODE
else
  mv "/etc/exports" "$server_nfs_bak/exports.bak"
fi

# Add the new conf
if [ ! -f "$server_nfs_conf/exports" ]; then
  echo "(nfs)new file /$server_nfs_conf does not exist"
  echo $ERROR_CODE
else
  cp "$server_nfs_conf/exports" "/etc/exports"
fi
