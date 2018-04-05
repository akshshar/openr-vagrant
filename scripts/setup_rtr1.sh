#!/bin/bash

echo "Running provisioning sript for rtr1" 


cp /vagrant/scripts/run_openr_rtr1.sh /usr/sbin/run_openr.sh
chmod 777 /usr/sbin/run_openr.sh

# Set up interfaces and ip addresses

ip addr add fd10:dba::10/64 dev eth1 
ip addr add 10.1.1.10/24  dev eth1
ip link set dev eth1 up

ip addr add fd11:dba::10/64 dev eth2 
ip addr add 11.1.1.10/24  dev eth2                        
ip link set dev eth2 up

# Set up hostname
hostname rtr1
echo "rtr1" > /etc/hostname
echo "127.0.0.1 rtr1" >> /etc/hosts
echo "127.0.1.1 rtr1" >> /etc/hosts
