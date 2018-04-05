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

ip addr add fd10:dba::10/64 dev eth1 
ip addr add 10.1.1.10/24  dev eth1
ip link set dev eth1 up

ip addr add fd11:dba::10/64 dev eth2 
ip addr add 11.1.1.10/24  dev eth2                        
ip link set dev eth2 up

ip addr add fd12:dba::10/64 dev eth3     
ip addr add 12.1.1.10/24  dev eth3   
ip link set dev eth3 up 

ip addr add fd14:dba::10/64 dev eth4
ip addr add 14.1.1.10/24  dev eth4
ip link set dev eth4 up

# Set up hostname
hostname rtr1
echo "rtr1" > /etc/hostname
echo "127.0.0.1 rtr1" >> /etc/hosts
echo "127.0.1.1 rtr1" >> /etc/hosts
