#!/usr/bin/expect
set username [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $username@$hostname
expect {

            #first connect == no public key in ~/.ssh/known_hosts

            "Are you sure you want to continue connecting (yes/no)?" {

            send "yes\r"

            expect "password:"

                send "$password\r"

            }
            #have connected before == already has public key in ~/.ssh/known_hosts

            "password:" {

                send "$password\r"

            }
        }
