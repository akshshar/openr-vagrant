#!/bin/bash

echo "Running provisioning sript for rtr1" 

cp /vagrant/scripts/run_openr_rtr2.sh /usr/sbin/run_openr.sh
chmod 777 /usr/sbin/run_openr.sh

# Setup up interfaces and ip addresses

ip addr add fd10:dba::20/64 dev eth1 
ip addr add 10.1.1.20/24  dev eth1
ip link set dev eth1 up

ip addr add fd11:dba::20/64 dev eth2 
ip addr add 11.1.1.20/24  dev eth2                        
ip link set dev eth2 up

# Set up hostname
hostname rtr2
echo "rtr2" > /etc/hostname
echo "127.0.0.1 rtr2" >> /etc/hosts
echo "127.0.1.1 rtr2" >> /etc/hosts
