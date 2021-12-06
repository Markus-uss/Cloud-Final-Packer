#!/bin/bash

sleep 30

sudo yum update -y

# install nodejs
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs

sudo yum install unzip -y
cd ~/ && unzip social_something_full.zip 
cd ~/social_someting_full && npm i --only=prod

# Setup the express app service 
sudo mv /tmp/socialSomething.service /etc/systemd/system/socialSomething.service
sudo systemctl enable socialSomething.service
sudo systemctl start socialSomething.service

#Install and set up cloud watch
sudo yum install -y awslogs
sudo sed -i 's+/var/log/messages+social_something_logs+g' /etc/awslogs/awslogs.conf
sudo sed -i 's+us-east-1+us-west-2+g' /etc/awslogs/awscli.conf
sudo systemctl start awslogsd
sudo systemctl enable awslogsd.service
