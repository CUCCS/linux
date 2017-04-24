#!/usr/bin/expect

set ip [lindex $argv 0 ] 
set username [lindex $argv 1 ] 
set password [lindex $argv 2 ] 
set keypath [lindex $argv 3 ] 

spawn ssh-copy-id -i ${keypath} $username@$ip
expect {  
 "*yes/no" { send "yes\r" ; exp_continue }  
 "*password:" { send "$password\r" ; exp_continue }
 "*password:" { send "$password\r" ; }
}
expect eof
