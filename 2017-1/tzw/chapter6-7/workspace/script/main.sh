# create directory
[[ -d "bak" ]] || {
	mkdir "bak"
}
[[ -d "bak/ftp" ]] || {
	mkdir "bak/ftp"
}
[[ -d "bak/nfs" ]] || {
	mkdir "bak/nfs"
}
[[ -d "bak/dhcp" ]] || {
	mkdir "bak/dhcp"
}
[[ -d "bak/samba" ]] || {
	mkdir "bak/samba"
}
[[ -d "bak/dns" ]] || {
	mkdir "bak/dns"
}
# Version Match
./script/version_match.sh
ret=$? && [[ $ret -eq 0 ]] || {
        echo "version match error with ret code $ret"
        exit $ret
}

# apt action
./script/apt.sh
ret=$? && [[ $ret -eq 0 ]] || {
	echo "apt part error with ret code $ret"
	exit $ret
}

# ftp server action
./script/ftp.sh
ret=$? && [[ $ret -eq 0 ]] || {
	echo "ftp part error with ret code $ret"
	exit $ret
}

# nfs server action
./script/nfs.sh
ret=$? && [[ $ret -eq 0 ]] || {
        echo "nfs part error with ret code $ret"
        exit $ret
}

# dhcp server action
./script/dhcp.sh
ret=$? && [[ $ret -eq 0 ]] || {
        echo "dhcp part error with ret code $ret"
        exit $ret
}

# samba server action
./script/samba.sh
ret=$? && [[ $ret -eq 0 ]] || {
        echo "samba part error with ret code $ret"
        exit $ret
}

# DNS server action
./script/dns.sh
ret=$? && [[ $ret -eq 0 ]] || {
        echo "dns part error with ret code $ret"
        exit $ret
}
