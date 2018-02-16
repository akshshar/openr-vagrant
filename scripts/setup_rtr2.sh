#!/bin/bash

echo "Running provisioning sript for rtr1" 

# Clone and install open/R

apt-get update && apt-get install git pkg-config
git clone https://github.com/akshshar/openr.git /root/openr && cd /root/openr/ && git checkout openr20171212 && cd /root/openr/build && ./build_openr_dependencies.sh
cd /root/openr/build && ./build_openr.sh && ./remake_glog.sh && cd /root/ && rm -r /root/openr

cp /vagrant/scripts/run_openr_rtr2.sh /usr/sbin/run_openr.sh
chmod 777 /usr/sbin/run_openr.sh

# Setup up interfaces and ip addresses

ip addr add fd10:dba::20/64 dev enp0s8 
ip addr add 10.1.1.20/24  dev enp0s8
ip link set dev enp0s8 up

ip addr add fd11:dba::20/64 dev enp0s9 
ip addr add 11.1.1.20/24  dev enp0s9                        
ip link set dev enp0s9 up

ip addr add fd12:dba::20/64 dev enp0s10     
ip addr add 12.1.1.20/24  dev enp0s10   
ip link set dev enp0s10 up 

ip addr add fd20:dba::10/64 dev enp0s16
ip addr add 20.1.1.10/24  dev enp0s16
ip link set dev enp0s16 up

ip addr add fd21:dba::10/64 dev enp0s17
ip addr add 21.1.1.10/24  dev enp0s17
ip link set dev enp0s17 up

ip addr add fd22:dba::10/64 dev enp0s18
ip addr add 22.1.1.10/24  dev enp0s18
ip link set dev enp0s18 up

# Set up hostname
hostname rtr2
echo "rtr2" > /etc/hostname
echo "127.0.0.1 rtr2" >> /etc/hosts
echo "127.0.1.1 rtr2" >> /etc/hosts
