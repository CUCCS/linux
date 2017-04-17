source ./script/global_conf.sh
ssh $server_root_name@$server_hostonly_ip << EOF

chmod -R 755 script
chmod -R 644 conf
echo "chmod success"
./script/init.sh

EOF
