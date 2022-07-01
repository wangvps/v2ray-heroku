#!/bin/sh

apt update -y
apt install -y curl

read -p "请输入CPU架构，例如:amd64 arm64不支持s390x:" CPU
mkdir -p /cloudreve
wget -O /cloudreve/cloudreve.zip https://github.com/cloudreve/Cloudreve/releases/download/3.5.3/cloudreve_3.5.3_linux_${CPU}.tar.gz
tar -zxvf /cloudreve/cloudreve.zip 
touch /cloudreve/conf.ini

read -p "请输入数据库类型，支持sqlite/mysql/mssql/postgres:" SQL_TYPE
read -p "请输入数据库连接端口:" SQL_PORT
read -p "请输入数据库名称:" SQL_NAME
read -p "请输入用户名:" SQL_USER
read -p "请输入密码:" SQL_PASSWORD
read -p "请输入数据库链接:" SQL_HOST
read -p "请输入redis数据库链接，格式 server:port:" REDIS_SERVER
read -p "请输入redis数据库密码:" REDIS_PASSWORD

cat << EOF > /cloudreve/conf.ini
[System]
Debug = false
Mode = master
Listen = :5212
SessionSecret = 5gECeS0SbJb9fnG9CNKpkYF6wjd1xhjuzqR9bztw5XEIQMnLJOIFmVaZi1wZ1N8Y
HashIDSalt = icYPGgJeBkG83G113G4FLogt7FT4WCJDXT65O5PsRuXBogwyeN1V0ibnzSLdijQ4

[Database]
Type = ${SQL_TYPE}
Port = ${SQL_PORT}
User = ${SQL_USER}
Password = ${SQL_PASSWORD}
Host = ${SQL_HOST}
Name = ${SQL_NAME}
TablePrefix = cd_
Charset = utf8

[Redis]
Server = ${REDIS_SERVER}
Password = ${REDIS_PASSWORD}
DB = 0
EOF

echo 完成初步配置!接下来配置守护进程

apt install -y systemctl
touch /usr/lib/systemd/system/cloudreve.service
cat << EOF > /usr/lib/systemd/system/cloudreve.service
[Unit]
Description=Cloudreve
Documentation=https://docs.cloudreve.org
After=network.target
After=mysqld.service
Wants=network.target

[Service]
WorkingDirectory=/cloudreve
ExecStart=/cloudreve/cloudreve
Restart=on-abnormal
RestartSec=5s
KillMode=mixed

StandardOutput=null
StandardError=syslog

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable cloudreve

echo 配置完成!请自行启动cloudreve以获得初始密码。命令:/PATH_TO_CLOUDREVE/cloudreve -c /PATH_TO_CLOUDREVE/conf.ini
echo 开始配置离线下载，使用docker配置

sleep 5
clear

echo 正在安装docker

curl -fsSL https://get.docker.com | bash
curl -L "https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

wget git.io/aria2-pro.yml
read -p "请设置RPC令牌" RPC
sed -i 's/<TOKEN>/${RPC}/g' aria2-pro.yml

docker-compose -f aria2-pro.yml up -d

echo done!
