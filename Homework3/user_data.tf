locals {
  webserver-instance-userdata = <<USERDATA
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
AWS_INSTANCE_HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`
sed -i "s/nginx/Grandpa's Whiskey hostname:$AWS_INSTANCE_HOSTNAME/g" /var/www/html/index.nginx-debian.html
sed -i '15,23d' /var/www/html/index.nginx-debian.html
service nginx restart
sudo apt install -y  awscli
(crontab -l 2>/dev/null; echo '00 *  * * *  aws s3 cp /var/log/nginx/access.log s3://${var.bucket_name}/') | crontab -

USERDATA
}

