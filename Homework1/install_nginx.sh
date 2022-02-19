#! /bin/bash
sudo apt-get install -y nginx
sudo su -c "echo Welcome to Grandpa\'s Whiskey >>/var/www/html/index.html"
sudo systemctl start nginx
sudo systemctl enable  nginx

