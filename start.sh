#!/bin/sh

apt update -y 
apt install -y wget curl

read -p "请输入CPU架构，例如:amd64 arm64不支持s390x:" CPU

mkdir -p /root/cloudreve
wget -O /root/cloudreve/cloudreve.zip https://github.com/cloudreve/Cloudreve/releases/download/3.5.3/cloudreve_3.5.3_linux_${CPU}.tar.gz
tar -zxvf /root/cloudreve/cloudreve.zip 
touch /root/cloudreve/conf.ini
read -p "请输入数据库名称:" SQL_NAME
read -p "请输入用户名:" SQL_USER
read -p "请输入密码:" SQL_PASSWORD
read -p "请输入数据库链接:" SQL_HOST

cat << EOF > /root/cloudreve/conf.ini
[System]
Debug = false
Mode = master
Listen = :5212
SessionSecret = 5gECeS0SbJb9fnG9CNKpkYF6wjd1xhjuzqR9bztw5XEIQMnLJOIFmVaZi1wZ1N8Y
HashIDSalt = icYPGgJeBkG83G113G4FLogt7FT4WCJDXT65O5PsRuXBogwyeN1V0ibnzSLdijQ4

[Database]
Type = mysql
Port = 3306
User = ${SQL_USER}
Password = ${SQL_PASSWORD}
Host = ${SQL_HOST}
Name = ${SQL_NAME}
TablePrefix = cd_
Charset = utf8
EOF

