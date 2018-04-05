## Openr on Linux using Vagrant

### Topology

![openr_vagrant](/openr_vagrant.png)


The topology consists of two ubuntu 16.04 instances (rtr1 and rtr2) connected through an ubuntu switch:  

><https://github.com/akshshar/openr-vagrant>{:target="_blank"}


The switch in the middle is a nice-to-have. It allows you to capture packets as the two nodes rtr1 and rtr2 exchange hellos and peering messages.
  
    
### The Vagrantfiles

The relevant `Vagrantfiles` in the repository are divided into two buckets:  
  
  *  **Pre-Built**: A pre-built ubuntu-16.04 vagrant box with open/R already built and installed has been published on vagrantcloud [here](https://app.vagrantup.com/ciscoxr/boxes/openr-xr_ubuntu/versions/1.0.0). The box is built using the hash: `a14e09abc0fcbe5835b45f549d48c09935d17f87` of <https://github.com/akshshar/openr-xr> as of April 5, 2018. This box is referenced in the `Vagrantfile` at the root of the git repo.
  
  *  **Latest Build**: If you'd like to build the boxes from scratch, drop into the `vagrant_build_latest/` folder before issuing a `vagrant up`.  
    
    
    
### Steps to run the setup

Clone the git repo and issue a `vagrant up` inside the directory:

If you're behind a proxy, just populate the `<git repo directory>/scripts/http_proxy` `<git repo directory>/scripts/https_proxy` files before issuing a `vagrant up`.
  
    
    

<div class="highlighter-rouge">
<pre class="highlight">
<code>
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



</code>
</pre>
</div>

The provisioning scripts set up the ip addresses on the connecting ports of rtr1 and rtr2. The Vagrantfile uses a pre-built Vagrant box located [here](https://app.vagrantup.com/ciscoxr/boxes/openr-xr_ubuntu/versions/1.0.0)
 

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

<div class="highlighter-rouge">
<pre class="highlight">
<code>
AKSHSHAR-M-K0DS:openr-two-nodes akshshar$<mark> vagrant ssh switch </mark>

#######################  snip #############################

Last login: Thu Feb 15 11:04:25 2018 from 10.0.2.2
vagrant@vagrant-ubuntu-trusty-64:~$<mark> sudo tcpdump -i br0 -w /vagrant/openr.pcap </mark>
tcpdump: listening on br0, link-type EN10MB (Ethernet), capture size 262144 bytes


</code>
</pre>
</div>

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

> rtr1's adjacencies, version: 26, Node Label: 13277, Overloaded?: False
Neighbor    Local Interface    Remote Interface      Metric    Weight    Adj Label  NextHop-v4    NextHop-v6                Uptime
rtr2        eth1               eth1                       6         1        50003  10.1.1.20     fe80::a00:27ff:fe7e:496   8m52s
rtr2        eth2               eth2                       4         1        50004  11.1.1.20     fe80::a00:27ff:fe93:99dd  8m52s


```


Let's look at the fib state in Open/R using the breeze cli:

```
vagrant@rtr1:~$ breeze fib list

== rtr1's FIB routes by client 786  ==

> 100.1.1.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

> 100.1.10.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

> 100.1.100.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

> 100.1.101.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

> 100.1.102.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

> 100.1.103.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

> 100.1.104.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

> 100.1.105.0/24
via 11.1.1.20@eth2
via 10.1.1.20@eth1

......

```

If you used the default route-scaling script on rtr2, then rtr1 should now have about 1000 routes in its fib:  


```
vagrant@rtr1:~$ breeze fib counters

== rtr1's Fib counters  ==

fibagent.num_of_routes : 1004

vagrant@rtr1:~$ 

```

In this case Open/R is launched using the **NetlinkFibHandler** (Open up /usr/sbin/run_openr.sh on either rtr1 and take a look at ENABLE_NETLINK_FIB_HANDLER=true directive). As a result, the FIB on rtr1 gets downloaded to the Linux kernel and we can view the routes using `ip route`:  

```
vagrant@rtr1:~$ ip route
default via 10.0.2.2 dev eth0 
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15 
10.1.1.0/24 dev eth1  proto kernel  scope link  src 10.1.1.10 
11.1.1.0/24 dev eth2  proto kernel  scope link  src 11.1.1.10 
60.1.1.1  proto 99 
	nexthop via 10.1.1.20  dev eth1 weight 1
	nexthop via 11.1.1.20  dev eth2 weight 1
100.1.1.0/24  proto 99 
	nexthop via 10.1.1.20  dev eth1 weight 1
	nexthop via 11.1.1.20  dev eth2 weight 1
100.1.2.0/24  proto 99 
	nexthop via 10.1.1.20  dev eth1 weight 1
	nexthop via 11.1.1.20  dev eth2 weight 1
100.1.3.0/24  proto 99 
	nexthop via 10.1.1.20  dev eth1 weight 1
	nexthop via 11.1.1.20  dev eth2 weight 1
100.1.4.0/24  proto 99 
	nexthop via 10.1.1.20  dev eth1 weight 1
	nexthop via 11.1.1.20  dev eth2 weight 1

.....

```
  
Great! These outputs should give you a fair gist of how Open/R works as a link state routing protocol. 


**Note**: The route updates are exchanged by the routers frequently over the established adjacencies. So subsequent updates may modify the next hop entries (10.1.1.20 or 11.1.1.20 seen in the outputs above) based on the content of the latest update. The outputs above were captured when the latest route updates were received for both the discovered next hop interfaces.  

