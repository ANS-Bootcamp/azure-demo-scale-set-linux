#!/bin/bash

# Configure Environment Variables
echo "port=80" >> /etc/environment
echo $1 >> /etc/environment
echo $2 >> /etc/environment

# Configure Script Variables
path = "/ans"
gitAccount = "nathanguk"
gitRepo = "azure-demo-gallery-linux"

#Update Server
apt-get -y update
apt-get -y upgrade

# Download and install Node.JS
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get -y install nodejs

# Install Unzip
apt-get -y install unzip

# Download and unzip application files
mkdir $path
resourcePath = /$gitAccount/$gitRepo/archive/master.zip
url = https://github.com$resourcePath 

curl -sL $url -o /ans/master.zip
unzip $path/master.zip -d $path

npm install -g pm2
npm install --prefix $path/$gitRepo
pm2 start $path/$gitRepo/bin/www
pm2 startup systemd

