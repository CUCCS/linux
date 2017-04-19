apt-get update
ret=$? && [[ $ret -eq 0 ]] || {
	echo "apt-get update failed with ret code $ret"	
	exit $ret
}
apt-get install expect -y
ret=$? && [[ $ret -eq 0 ]] || {
	echo "expect installed with ret code $ret"
	exit $ret
}
