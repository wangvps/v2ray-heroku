#!/bin/sh
# V2Ray new configuration
# Run V2ray
# Write V2Ray configuration
cat <<-EOF > /etc/v2ray/config.json
{
    "inbounds": [{
        "port": 80,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "ba651c8c-cb35-4c46-bf6c-f90bd6f094e3",
                "alterId": 0
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "/laowang"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

#Run V2ray

/usr/bin/v2ray/v2ray -config=/etc/v2ray/config.json
