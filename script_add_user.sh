#!/bin/bash
# Script to add a user to DMZ 
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -p "Enter comment : " comment
        read -s -p "Enter password : " password
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass $username -g 1001 -s /sbin/nologin -c "$comment" -k /etc/alter_skel
                [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
                mkdir /home/$username/.ssh
                mkdir -m 2755 /home/$username/dev
                mkdir -m 2755 /home/$username/etc
                mkdir -m 1755 /home/$username/incoming
                mkdir -m 1755 /home/$username/outgoing
		mkdir -m 1755 /home/dmzc_s02/incoming/$username
		mkdir -m 1755 /home/dmzc_s02/outgoing/$username
		chown dmzc_s02. /home/dmzc_s02/incoming/$username
		chown dmzc_s02. /home/dmzc_s02/incoming/$username
		cp /usr/share/zoneinfo/Africa/Cairo /home/$username/etc/localtime
                chown $username. /home/$username/incoming
                chown $username. /home/$username/outgoing
                chown root. /home/$username
        fi
else
        echo "Only root may add a user to the system"
        exit 2
fi
