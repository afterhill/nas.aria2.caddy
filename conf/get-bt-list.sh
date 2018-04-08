#!/bin/sh

list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" /root/conf/aria2.conf`" ]; then
    sed -i '$a bt-tracker='${list} /root/conf/aria2.conf
    echo "add bt tracker list" > /proc/1/fd/1 2>/proc/1/fd/2
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" /root/conf/aria2.conf
    echo "update bt tracker list" > /proc/1/fd/1 2>/proc/1/fd/2
fi

killall caddy
