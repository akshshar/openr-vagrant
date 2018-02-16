# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(2) do |config|
  

   config.vm.define "rtr1" do |rtr1|
      rtr1.vm.box =  "bento/ubuntu-16.04"

      rtr1.vm.network "forwarded_port", guest: 57777, host: 57777, auto_correct: true 

      # gig0/0/0/0 connected to "link1", gig0/0/0/1 connected to "link2"
      # auto_config is not supported for XR, set to false

      rtr1.vm.network :private_network, virtualbox__intnet: "link1", auto_config: false
      rtr1.vm.network :private_network, virtualbox__intnet: "link2", auto_config: false
      rtr1.vm.network :private_network, virtualbox__intnet: "link3", auto_config: false
      rtr1.vm.network :private_network, virtualbox__intnet: "link7", auto_config: false

      rtr1.vm.provision "apply_config", type: "shell" do |s|
          s.path =  "scripts/setup_rtr1.sh"
          s.args = '#{ENV['http_proxy']} #{ENV['https_proxy']}'
      end

      rtr1.vm.provider "virtualbox" do |v|
         v.cpus = 2
         v.memory = 1024 
         v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
      end
    end

   config.vm.define "switch" do |switch|
      switch.vm.box =  "ubuntu/trusty64"

      switch.vm.network "forwarded_port", guest: 57777, host: 57778, auto_correct: true
      # gig0/0/0/0 connected to "link1"  and  gig0/0/0/1 connected to "link2"
      # auto_config is not supported for XR, set to false

      switch.vm.network :private_network, virtualbox__intnet: "link1", auto_config: false
      switch.vm.network :private_network, virtualbox__intnet: "link2", auto_config: false
      switch.vm.network :private_network, virtualbox__intnet: "link3", auto_config: false
      switch.vm.network :private_network, virtualbox__intnet: "link4", auto_config: false
      switch.vm.network :private_network, virtualbox__intnet: "link5", auto_config: false
      switch.vm.network :private_network, virtualbox__intnet: "link6", auto_config: false


      switch.vm.provision "apply_config", type: "shell" do |s|
          s.path =  "scripts/setup_switch.sh"
          s.args = '#{ENV['http_proxy']} #{ENV['https_proxy']}'
      end

      switch.vm.provider "virtualbox" do |v|
         v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc5", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc6", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc7", "allow-all"]
     end
    end



   config.vm.define "rtr2" do |rtr2|
      rtr2.vm.box =  "bento/ubuntu-16.04"

      rtr2.vm.network "forwarded_port", guest: 57777, host: 57778, auto_correct: true
      # gig0/0/0/0 connected to "link1"  and  gig0/0/0/1 connected to "link2"
      # auto_config is not supported for XR, set to false

      rtr2.vm.network :private_network, virtualbox__intnet: "link4", auto_config: false
      rtr2.vm.network :private_network, virtualbox__intnet: "link5", auto_config: false
      rtr2.vm.network :private_network, virtualbox__intnet: "link6", auto_config: false
      rtr2.vm.network :private_network, virtualbox__intnet: "link10", auto_config: false
      rtr2.vm.network :private_network, virtualbox__intnet: "link11", auto_config: false
      rtr2.vm.network :private_network, virtualbox__intnet: "link12", auto_config: false

      rtr2.vm.provision "apply_config", type: "shell" do |s|
          s.path =  "scripts/setup_rtr2.sh"
          s.args = '#{ENV['http_proxy']} #{ENV['https_proxy']}'
      end

      rtr2.vm.provider "virtualbox" do |v|
         v.memory = 512 
         v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc5", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc6", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc7", "allow-all"]
     end
    end

   config.vm.define "rtr3" do |rtr3|
      rtr3.vm.box =  "openr"

      rtr3.vm.network "forwarded_port", guest: 57777, host: 57778, auto_correct: true
      # gig0/0/0/0 connected to "link1"  and  gig0/0/0/1 connected to "link2"
      # auto_config is not supported for XR, set to false

      rtr3.vm.network :private_network, virtualbox__intnet: "link10", auto_config: false
      rtr3.vm.network :private_network, virtualbox__intnet: "link11", auto_config: false
      rtr3.vm.network :private_network, virtualbox__intnet: "link12", auto_config: false

      rtr3.vm.provision "apply_config", type: "shell" do |s|
          s.path =  "scripts/setup_rtr3.sh"
      end

      rtr3.vm.provider "virtualbox" do |v|
         v.memory = 512
         v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
         v.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
     end
    end

   config.vm.define "xr" do |xr|
      xr.vm.box =  "IOS-XRv-622"

      xr.vm.network "forwarded_port", guest: 57777, host: 57779, auto_correct: true
      # gig0/0/0/0 connected to "link1"  and  gig0/0/0/1 connected to "link2"
      # auto_config is not supported for XR, set to false

      xr.vm.network :private_network, virtualbox__intnet: "link7", auto_config: false
      xr.vm.network :private_network, virtualbox__intnet: "link8", auto_config: false
      xr.vm.network :private_network, virtualbox__intnet: "link9", auto_config: false
       
  
      #Source a config file and apply it to XR

      xr.vm.provision "file", source: "configs/rtr_config", destination: "/home/vagrant/rtr_config"

      xr.vm.provision "apply_config", type: "shell" do |s|
          s.path =  "scripts/apply_config.sh"
          s.args = ["/home/vagrant/rtr_config"]
      end

      xr.vm.provider "virtualbox" do |v|
         v.memory = 4096
     end
    end

end
