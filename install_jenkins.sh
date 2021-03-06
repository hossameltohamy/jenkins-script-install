#!/bin/bash

# this script is only tested on ubuntu xenial

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu
DockerFile=./Dockerfile 
# Buld   jenkins Image
mkdir -p /var/jenkins_home
chown -R 1000:1000 /var/jenkins_home/

if [ -f "$DockerFile" ];
then
echo " Jenkins DockerFile is exist Start building jenkins for you, please wait....."
 docker build .
 docker run -p 8080:8080 -p 50000:50000  -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home:/var/jenkins_home -d --name jenkins jenkins/jenkins:lts-jdk11

# show endpoint
echo 'Jenkins installed'
echo 'You should now be able to access jenkins at: http://'$(curl -s ifconfig.co)':8080'
else
echo "No DockerFile exist"
fi

