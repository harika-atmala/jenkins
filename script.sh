#!/bin/bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sleep 05
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sleep 05
sudo apt-get -y update
sleep 10
sudo apt-get -y install jenkins
sleep 10
sudo service jenkins start
