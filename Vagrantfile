Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"  # Ubuntu 22.04 LTS
  config.vm.network "forwarded_port", guest: 8080, host: 8080    # Jenkins
  config.vm.network "forwarded_port", guest: 80,   host: 8081    # site web (accès : http://localhost:8081)
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Provision via script local
  config.vm.provision "shell", path: "provision.sh"
end
