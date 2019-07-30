#!/usr/bin/env bash

if ! hash caddy 2>/dev/null; then
curl https://getcaddy.com | sudo bash -s personal tls.dns.dnspod,http.expires,http.cache
# 为了给予caddy从非root用户（用sudo模式启动）绑定80、443等端口的权限，需要进行下面的配置，这个配置很重要，不执行这句话会导致caddy服务启动失败。
setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
adduser --home /var/www --shell /sbin/nologin --system --group www
mkdir -p /mnt/caddy/ssl
mkdir -p /mnt/caddy/include
if [ ! -f /mnt/caddy/Caddyfile ]; then
echo "import /mnt/caddy/include/*.caddy" > /mnt/caddy/Caddyfile
fi
chown -R www:www /mnt/caddy
mkdir -p /var/www
chown www:www /var/www
fi
