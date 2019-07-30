
if [ ! -f "/etc/systemd/system/caddy.service" ]; then
curl https://getcaddy.com | sudo bash -s personal tls.dns.dnspod,http.expires,http.cache
# 为了给予caddy从非root用户（用sudo模式启动）绑定80、443等端口的权限，需要进行下面的配置，这个配置很重要，不执行这句话会导致caddy服务启动失败。
setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
adduser -r -d /var/www -s /sbin/nologin www
fi
mkdir -p /var/www
chown www:www /var/www
