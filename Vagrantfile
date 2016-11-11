# -*- mode: ruby -*-
# vi: set ft=ruby :# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/centos-6.7"
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 5601, host: 5601
  config.vm.network :forwarded_port, guest: 5044, host: 5044
 
  config.vm.network "private_network", type: "dhcp"  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true
  config.vm.provider "virtualbox" do |vb|
    vb.name = "centos-elk"
  
    # Boot with headless mode
    vb.gui = false    # Tweak the below value to adjust RAM
    vb.memory = 2048
  
    # Tweak the number of processors below
    vb.cpus = 4
 
    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  config.vm.provision :shell, :path => "setup.sh"
end