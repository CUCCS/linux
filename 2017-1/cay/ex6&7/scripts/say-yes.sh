#!/usr/bin/expect

expect {

	"[Y/n]" {

        send "Y\r"
}
expect eof
