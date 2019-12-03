#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

/usr/local/vpnserver/vpnserver start
sleep 2

tail -F /usr/local/vpnserver/*_log/*.log &
sleep 2

/sbin/ip address add 172.16.0.1/24 brd + dev tap_default
ifconfig tap_default mtu $MTU
sleep 2
iptables -t nat -D POSTROUTING -s 172.16.0.0/24 -j MASQUERADE
#iptables -t mangle -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t filter-D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
sleep 2
iptables -t nat -A POSTROUTING -s 172.16.0.0/24 -j MASQUERADE
#iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
# 使用filter表修改mss,比使用mangle表修改mss ，VPN上传速度快很多
iptables -t filter -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
sleep 2

service dnsmasq  start

set +e
while pgrep vpnserver > /dev/null; do sleep 1; done
set -e

