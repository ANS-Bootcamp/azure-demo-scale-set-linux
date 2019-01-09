#!/bin/bash

# Configure Environment Variables
echo "PORT=80" >> /etc/environment
echo "AZURE_STORAGE_ACCOUNT=$1" >> /etc/environment
echo "AZURE_STORAGE_ACCESS_KEY=$2" >> /etc/environment

export "PORT=80"
export "AZURE_STORAGE_ACCOUNT=$1"
export "AZURE_STORAGE_ACCESS_KEY=$2"

# Configure Script Variables
path="/ans"
gitAccount="ANS-Bootcamp"
gitRepo="azure-demo-gallery-linux"
service="azuredemogallery"




