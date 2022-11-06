#!/bin/bash

sudo groupadd -g 9999 www-users
sudo useradd -s /sbin/nologin www-user -G www-users