source ./script/global_conf.sh
# PRE configuration settings
./pre_conf.sh
ret=$? && [[ $ret -eq 0 ]] || {
	echo "pre_conf error with ret code $ret"
	exit $ret
}

# SSH no_passwd
#./ssh_nopwd.sh $server_root_name $server_hostonly_ip $server_ssh_pwd $self_root_ssh_key
#ret=$? && [[ $ret -eq 0 ]] || {
#	echo "ssh_nopwd error with ret code $ret"
#	exit $ret
#}

# SSH copy_files
./copy_files.sh
ret=$? && [[ $ret -eq 0 ]] || {
	echo "copy_files error with ret code $ret"
	exit $ret
}

# SSH connect_execute
./connect_execute.sh
ret=$? && [[ $ret -eq 0 ]] || {
	echo "connect_execute error with ret code $ret"
	exit $ret
}
