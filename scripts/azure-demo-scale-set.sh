#!/bin/bash

# Configure Environment Variables
echo "PORT=80" >> /etc/environment
echo "STATUS=200" >> /etc/environment
echo "CPU=false" >> /etc/environment
echo "AZURE_STORAGE_ACCOUNT=$1" >> /etc/environment
echo "AZURE_STORAGE_ACCESS_KEY=$2" >> /etc/environment

export "PORT=80"
export "STATUS=200"
export "CPU=false"
export "AZURE_STORAGE_ACCOUNT=$1"
export "AZURE_STORAGE_ACCESS_KEY=$2"

# Configure Script Variables
path="/ans"
gitAccount="nathanguk"
gitRepo="azure-demo-gallery-linux"
service="azuredemogallery"

#Update Server
apt-get update -y
apt-get upgrade -y

# Download and install Node.JS
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs

# Install Unzip
apt-get install -y unzip

# Install Stress-Ng
apt-get install -y stress-ng

# Download and unzip application files
mkdir $path
resourcePath="/$gitAccount/$gitRepo/archive/master.zip"
url="https://github.com$resourcePath" 

curl -sL $url -o "/$path/master.zip"
unzip "$path/master.zip" -d $path

# Configure application as node service
npm install node-linux --prefix "$path/$gitRepo-master"
npm install --prefix "$path/$gitRepo-master"
node "$path/$gitRepo-master/service.js"
service $service start

# Brings loadbalancer back into service every 5 minutes
(crontab -l 2>/dev/null; echo "*/5 * * * * curl -s http://127.0.0.1/200 && curl -s http://127.0.0.1/cpulow") | crontab -

# Checks is CPU stress process needs loading every 1 minutes
(crontab -l 2>/dev/null; echo "*/1 * * * * if curl -s http://127.0.0.1/cpu | head -n 3 | grep -q 'true' ; then stress-ng -c 0 -l 75 -t 60s ; fi") | crontab -
