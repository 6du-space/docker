#!/usr/bin/env bash

sudo apt-get install postgresql postgresql-client -y
sudo /etc/init.d/postgresql start

DB_USER=psql
DB_NAME=$DB_USER
sudo -u postgres createuser --superuser $DB_USER
sudo -u postgres createdb --owner=$DB_USER $DB_NAME
