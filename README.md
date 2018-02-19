## Openr on Linux using Vagrant

### Topology

![openr_vagrant](/openr_vagrant.png)


The vagrant provisioners will install open/R on "vagrant up" on both rtr1 and rtr2 and will setup the required "run" script for openr at `/usr/sbin/run_openr.sh` on each node.

The switch in the middle is a nice-to-have. It allows you to capture packets as the two nodes rtr1 and rtr2 exchange hellos and peering messages.

Clone the git repo and issue a `vagrant up` inside the directory:

If you're behind a proxy, just populate the `<git repo directory>/scripts/http_proxy` `<git repo directory>/scripts/https_proxy` files before issuing a `vagrant up`.


```shell
cisco@host:~$ <mark> git clone https://github.com/akshshar/openr-vagrant </mark>
Cloning into 'openr-vagrant'...
remote: Counting objects: 31, done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 31 (delta 14), reused 26 (delta 12), pack-reused 0
Unpacking objects: 100% (31/31), done.
Checking connectivity... done.
cisco@host:~$ <mark>cd openr-vagrant/</mark>
cisco@host:~$ <mark>vagrant up</mark>
Bringing machine 'rtr1' up with 'virtualbox' provider...
Bringing machine 'switch' up with 'virtualbox' provider...
Bringing machine 'rtr2' up with 'virtualbox' provider...

```

### Reducing Bring up time
The provisioning scripts build open/R from scratch on rtr1 and rtr2, so expect this bringup to take a long time. You could parallelize the effort by commenting out the provisioners for rtr1 and rtr2  in the Vagrantfile, bring up the nodes, uncomment the provisioners and then run `vagrant provision rtr1` and `vagrant provision rtr2` in two separate terminals simultaneously.


Once the devices are up, issue a `vagrant ssh rtr1` and `vagrant ssh rtr2` in separate terminals and start open/R (The run scripts added to each node will automatically detect the interfaces and start discovering each other).  

Further, for rtr2, I've added a simple route-scaling python script that allows you to add up to 8000 routes by manipulating the `batch_size` and `batch_num` values in `<git repo directory>/scripts/increment_ipv4_prefix.py` before running /usr/sbin/run_openr.sh 


```
vagrant@rtr1:~$ /usr/sbin/run_openr.sh 
/usr/sbin/run_openr.sh: line 98: /etc/sysconfig/openr: No such file or directory
Configuration not found at /etc/sysconfig/openr. Using default configuration
openr[10562]: Starting OpenR daemon.

......


vagrant@rtr2:~$ /usr/sbin/run_openr.sh 
/usr/sbin/run_openr.sh: line 98: /etc/sysconfig/openr: No such file or directory
Configuration not found at /etc/sysconfig/openr. Using default configuration
openr[10562]: Starting OpenR daemon.

......

```




### Capturing Open/R Hellos and Peering messages

Start a tcpdump capture on one or more of the bridges on the switch in the middle:  

```shell
host:openr-two-nodes akshshar$<mark> vagrant ssh switch </mark>

#######################  snip #############################

Last login: Thu Feb 15 11:04:25 2018 from 10.0.2.2
vagrant@vagrant-ubuntu-trusty-64:~$<mark> sudo tcpdump -i br0 -w /vagrant/openr.pcap </mark>
tcpdump: listening on br0, link-type EN10MB (Ethernet), capture size 262144 bytes

```

Open up the pcap file in wireshark and you should see the following messages show up:

  *  **Hello Messages**: The hello messages are sent to UDP port 6666 to the All-Nodes IPv6 
     Multicast address ff02::1 and source IP = Link local IPv6 address of node. These messages are 
     used to discover neighbors and learn their link local IPv6 addresses.    
        
        
     
     ![Openr/R hello messages](/openr_hellos.png)
  
   
      
      
  *  **Peering Messages**: Once the link local IPv6 address of neighbor is known, 0MQ TCP messages 
     are sent out to create an adjacency with the neighbor on an interface. One such message is 
     shown below:  
         
            
            
     ![0MQ messages openr](/0mq_openr.png)   
         
         
  

### Open/R breeze CLI

Once the peering messages go through, adjacencies should get established with the neighbors on all connected interfaces. These adjacencies can be verified using the "breeze" cli:  

```
vagrant@rtr1:~$ breeze kvstore adj

> rtr1's adjacencies, version: 12, Node Label: 42122, Overloaded?: False
Neighbor    Local Interface    Remote Interface      Metric    Weight    Adj Label  NextHop-v4    NextHop-v6                Uptime
vagrant     enp0s9             enp0s9                     7         1        50004  0.0.0.0       fe80::a00:27ff:fed1:ba15  0m2s
vagrant     enp0s8             enp0s8                     8         1        50003  0.0.0.0       fe80::a00:27ff:fe94:3015  0m4s
vagrant     enp0s10            enp0s10                    7         1        50005  0.0.0.0       fe80::a00:27ff:fe36:aec9  0m6s


```


Let's look at the fib state in Open/R using the breeze cli:

```
vagrant@rtr1:~$ breeze fib list

== rtr1's FIB routes by client 786  ==

> 100.1.1.0/24
via 0.0.0.0@enp0s10
via 0.0.0.0@enp0s8
via 0.0.0.0@enp0s9

> 100.1.10.0/24
via 0.0.0.0@enp0s10
via 0.0.0.0@enp0s8
via 0.0.0.0@enp0s9

> 100.1.100.0/24
via 0.0.0.0@enp0s10

......

```

If you used the default route-scaling script on rtr2, then rtr1 should now have about 1000 routes in its fib:  


```
vagrant@rtr1:~$ breeze fib counters

== rtr1's Fib counters  ==

fibagent.num_of_routes : 1004

vagrant@rtr1:~$ 

```

Great! These outputs should give you a fair gist of how Open/R works as a link state routing protocol.

