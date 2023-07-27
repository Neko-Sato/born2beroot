#!/bin/bash

wall "\
	#Architecture: $(uname -a)
	#CPU physical : $(fgrep 'physical id' /proc/cpuinfo | wc -l)
	#vCPU : $(fgrep 'processor' /proc/cpuinfo | wc -l)
	#Memory $(free -m | awk '/Mem/ { printf("%d/%dMB (%.2f%%)\n", $2, $3, $3/$2*100) }')
	#Disk Usage: $(df -Bg --total | awk '/total/ { printf("%d/%dGb (%.2f%%)", $2, $3, $5) }')
	#CPU load: $(top -bn 1 | awk -F '[ ,]' 'NR==3 { printf("%.1f%%", $3) }')
	#Last boot: $(who -b | awk '$1 == "system" { printf("%s %s", $3, $4) }')
	#LVM use: $(if $(lsblk | grep "lvm" | wc -l); then echo no; else echo yes; fi)
	#Connections TCP : $(cat /proc/net/sockstat | awk '$1 == "TCP:" { printf("%d ESTABLISHED", $3) }')
	#User log: $(users | wc -w)
	#Network: $(hostname -I) $(ip link show | awk '/link\/ether/ { print $2 }')
	#Sudo : $(cat /var/log/sudo/sudo.log | grep COMMAND= | wc -l) cmd
"