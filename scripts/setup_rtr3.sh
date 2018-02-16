#!/bin/bash

echo "Running provisioning sript for rtr3" 

ip addr add fd20:dba::20/64 dev enp0s8 
ip addr add 20.1.1.20/24  dev enp0s8
ip link set dev enp0s8 up

ip addr add fd21:dba::20/64 dev enp0s9 
ip addr add 21.1.1.20/24  dev enp0s9                        
ip link set dev enp0s9 up

ip addr add fd22:dba::20/64 dev enp0s10     
ip addr add 22.1.1.20/24  dev enp0s10   
ip link set dev enp0s10 up 
