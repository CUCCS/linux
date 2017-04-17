#!usr/bin/expect -f
set user [lindex $argv 0]
set passwd [lindex $argv 1]
spawn passwd $user
expect "Enter new UNIX password:"
send "$passwd\r"

expect "Retype new UNIX password:"
send "$passwd\r"
expect eof

