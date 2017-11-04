# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"

  # config.vm.network "public_network"

  config.vm.synced_folder ".", "/vagrant/www", mount_options: ['dmode=777', 'fmode=777']

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 4096, "--cpus", 2, "--ioapic", "on"]
  end

  config.vm.provision :file, source: "vagrant/nginx/app.conf", destination: "app.conf"
  config.vm.provision :file, source: "vagrant/nginx/nginx.conf", destination: "nginx.conf"
  config.vm.provision :file, source: "vagrant/mysql/my.cnf", destination: "my.cnf"
  config.vm.provision :shell, path: "vagrant/bootstrap.sh"
  config.vm.provision :shell, path: "vagrant/bootstrap_vagrant.sh", privileged: false
end
