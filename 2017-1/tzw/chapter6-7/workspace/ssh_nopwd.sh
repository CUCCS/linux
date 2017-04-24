#!/usr/bin/expect -f
# 设置ssh连接的用户名
set user [lindex $argv 0]
# 设置ssh连接的host地址
set host [lindex $argv 1]
# 设置ssh连接的登录密码
set password [lindex $argv 2]
# 设置root用户公钥位置 
set pub [lindex $argv 3]

spawn ssh-copy-id -i $pub $user@$host
expect {
            #first connect, no public key in ~/.ssh/known_hosts
            "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
            expect "password:"
                send "$password\r"
            }
            #already has public key in ~/.ssh/known_hosts
            "password:" {
                send "$password\r"
            }
            "Now try logging into the machine" {
                #it has authorized, do nothing!
            }
        }
expect eof
