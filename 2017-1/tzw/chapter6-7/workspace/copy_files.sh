# Send scripts and conf via SCP
source ./script/global_conf.sh
scp -r script/ $server_root_name@$server_hostonly_ip:$server_root_path/script
scp -r conf/ $server_root_name@$server_hostonly_ip:$server_root_path/conf
