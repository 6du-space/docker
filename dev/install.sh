#!/usr/bin/env bash

NOWDIR=$(cd "$(dirname "$0")"; pwd)


cd ~/
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh_host()
{
ssh-keyscan -t rsa,dsa $1 >> ~/.ssh/known_hosts
}

ssh_host code.aliyun.com
ssh_host github.com
ssh_host gitee.com

sort -u -o  ~/.ssh/known_hosts ~/.ssh/known_hosts

cd $NOWDIR/os
git clone git@code.aliyun.com:ur-yun/home.git root --depth=1
rsync -av $NOWDIR/os/ /;

chmod 600 /etc/ssh/ssh_host_*_key
chmod 644 /etc/ssh/ssh_host_*_key.pub

updatedb

chsh -s /usr/bin/zsh root
