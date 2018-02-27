#!/bin/bash

# Configure Environment Variables
echo "PORT=80" >> /etc/environment
echo "AZURE_STORAGE_ACCOUNT=$1" >> /etc/environment
echo "AZURE_STORAGE_ACCESS_KEY=$2" >> /etc/environment

# Configure Script Variables
path="/ans"
gitAccount="nathanguk"
gitRepo="azure-demo-gallery-linux"

#Update Server
apt-get update -y
apt-get upgrade -y

# Download and install Node.JS
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs

# Install Unzip
apt-get install -y unzip

# Download and unzip application files
mkdir $path
resourcePath="/$gitAccount/$gitRepo/archive/master.zip"
url="https://github.com$resourcePath" 

curl -sL $url -o "/$path/master.zip"
unzip "$path/master.zip" -d $path

npm install -g pm2
npm install --prefix "$path/$gitRepo-master"
pm2 start "$path/$gitRepo-master/bin/www"
env PATH=$PATH:/usr/bin 
/usr/lib/node_modules/pm2/bin/pm2 startup systemd
