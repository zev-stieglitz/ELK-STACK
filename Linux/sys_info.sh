#!/bin/bash
#zzzz=/home/sysadmin/research2/sys_info.txt
zzzz=$zzzz"/home/sysadmin/research2/sys_info.txt"
mkdir research2 $zzzz
if [ -d /home/sysadmin/research2 ]
then
echo "dir already exsist BUCKO"
fi
echo -e "a System Audit script!" > $zzzz
echo -e "date:" >> $zzzz
date >> $zzzz
echo -e "Machine Type Information:" >> $zzzz
$MACHTYPE >> $zzzz
echo -e "Uname Info:" >> $zzzz
uname -a >> $zzzz
echo -e "IP Info:" >> $zzzz
(ip addr | head -9 | tail -1) >> $zzzz
echo -e "host:" >> $zzzz
hostname -s >> $zzzz
echo -e "DNS Servers:" >> $zzzz
sudo cat /etc/resolv.conf >> $zzzz
echo -e "MEM INFO:" >> $zzzz
free >> $zzzz
echo -e "CPU Usage:" >> $zzzz
lscpu | grep -i cpu >> $zzzz
echo -e "Disk Usage:" >> $zzzz
df -H | head -2 >> $zzzz
echo -e "currently logged on users:" >> $zzzz
who -a >> $zzzz
echo -e "\n777 Files" >> $zzzz
sudo find / -type f -perm 777 >> $zzzz
echo -e "\nTop 10 processes" >> $zzzz
sudo ps aux -m | awk '{print $1, $2, $3, $4, $11'} | head >> $zzzz
if [ -f /home/sysadmin/research2/sys_info.txt ]
then
echo "file is already in resesarch2 BUCKO!"
fi
#zzzz=$zzzz/home/sysadmin/research/sys_info.txt
