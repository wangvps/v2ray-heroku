#!/bin/sh

apt-get purge netfilter-persistent


iptables -P INPUT ACCEPT

iptables -P FORWARD ACCEPT

iptables -P OUTPUT ACCEPT

iptables -F
