#!/bin/sh

apt update -y 
apt install -y wget curl

echo 输入cpu架构,例如amd64,arm64,不支持s390x: $cpu

mkdir -p /root/cloudreve

wget -O /root/cloudreve/cloudreve.zip https://github.com/cloudreve/Cloudreve/releases/download/3.5.3/cloudreve_3.5.3_linux_${cpu}.tar.gz

tar -zxvf /root/cloudreve/cloudreve.zip 

touch /root/cloudreve/conf.ini

cat <EOF > /root/cloudreve/conf.ini
