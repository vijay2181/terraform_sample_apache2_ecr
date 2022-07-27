#!/bin/bash

yum update -y

#Installing PYTHON 3.9
yum -y groupinstall "Development Tools"
yum -y install openssl-devel bzip2-devel libffi-devel
yum -y install wget
cd /opt
wget https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tgz
tar xvf Python-3.9.10.tgz
cd Python-*/
./configure --enable-optimizations
sudo make altinstall
/usr/local/bin/python3.9 -m pip install --upgrade pip
pip3.9 install awscli --user

#python3.9 -V

#installing docker
yum install -y docker

# Adding ec2-user users to docker group
gpasswd -M ec2-user docker

#Starting service
systemctl start docker
systemctl enable docker
systemctl start sysstat
systemctl enable sysstat


# Installing docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
