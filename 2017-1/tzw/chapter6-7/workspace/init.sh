source ./script/global_conf.sh
# PRE configuration settings
./pre_conf.sh

# SSH no_passwd
./ssh_nopwd.sh $server_root_name $server_hostonly_ip $server_ssh_pwd $self_root_ssh_key

# SSH copy_files
./copy_files.sh

# SSH connect_execute
./connect_execute.sh
