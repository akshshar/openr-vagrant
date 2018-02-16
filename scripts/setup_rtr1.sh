#!/bin/bash

echo "Running provisioning sript for rtr1" 

# Clone and install open/R
http_proxy=`cat /vagrant/scripts/http_proxy`
https_proxy=`cat /vagrant/scripts/https_proxy`

export http_proxy=${http_proxy} && export https_proxy=${http_proxy} && apt-get update && apt-get install -y git pkg-config
export http_proxy=${http_proxy} && export https_proxy=${http_proxy} &&  git clone https://github.com/akshshar/openr-xr.git /home/vagrant/openr && cd /home/vagrant/openr/ && git checkout linux_openr && cd /home/vagrant/openr/build && ./build_openr_dependencies.sh
export http_proxy=${http_proxy} && export https_proxy=${http_proxy} &&  cd /home/vagrant/openr/build && ./build_openr.sh && ./remake_glog.sh 

cp /vagrant/scripts/run_openr_rtr1.sh /usr/sbin/run_openr.sh
chmod 777 /usr/sbin/run_openr.sh

# Set up interfaces and ip addresses

ip addr add fd10:dba::10/64 dev enp0s8 
ip addr add 10.1.1.10/24  dev enp0s8
ip link set dev enp0s8 up

ip addr add fd11:dba::10/64 dev enp0s9 
ip addr add 11.1.1.10/24  dev enp0s9                        
ip link set dev enp0s9 up

ip addr add fd12:dba::10/64 dev enp0s10     
ip addr add 12.1.1.10/24  dev enp0s10   
ip link set dev enp0s10 up 

ip addr add fd14:dba::10/64 dev enp0s16
ip addr add 14.1.1.10/24  dev enp0s16
ip link set dev enp0s16 up

# Set up hostname
hostname rtr1
echo "rtr1" > /etc/hostname
echo "127.0.0.1 rtr1" >> /etc/hosts
echo "127.0.1.1 rtr1" >> /etc/hosts
