#!/bin/bash

echo "Running provisioning sript for rtr1" 

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
