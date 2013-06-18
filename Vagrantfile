Vagrant.configure("2") do |config|
  
  config.vm.define :graphite do |graphite|
    graphite.vm.box = "centos64-dev20130612.1"
    graphite.ssh.forward_agent = true
    graphite.ssh.forward_x11 = true
    graphite.vm.hostname = "graphite"
    graphite.vm.provision :shell, :path => "scripts/graphite_bootstrap.sh"
    graphite.vm.network :forwarded_port, guest: 80, host: 8080
    graphite.vm.network :private_network, ip: "192.168.50.10"
    graphite.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
      v.customize ["modifyvm", :id, "--memory", "768"]
    end
  end

  config.vm.define :client1 do |client1|
    client1.vm.box = "centos64-dev20130612.1"
    client1.vm.hostname = "client1"
    client1.vm.network :private_network, ip: "192.168.50.11"
    client1.vm.provision :shell, :path => "scripts/client_bootstrap.sh"
    client1.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--cpuexecutioncap", "15"]
    end
  end
  
end

