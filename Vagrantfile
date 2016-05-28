# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2" 

# Create local caching for packages
def local_cache(box_name)
  cache_dir = File.join(File.dirname(__FILE__), '.vagrant_cache', 'apt', box_name)
  partial_dir = File.join(cache_dir, 'partial')
  FileUtils.mkdir_p(partial_dir) unless File.exists? partial_dir
  cache_dir
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  # Work around cosmetic issue (default uses -l which misbehaves when not in interactive shell)
  config.ssh.shell = "/bin/bash"

  config.r10k.puppet_dir = "puppet"
  config.r10k.puppetfile_path = "Puppetfile"
  config.r10k.module_path = "puppet/modules"

  cache_dir = local_cache(config.vm.box)
  config.vm.synced_folder cache_dir, "/var/cache/apt/archives/"

  config.vm.define :foreman do |fm|
    fm.vm.hostname = "foreman.example.net"
    fm.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    fm.vm.network "private_network", ip: "10.10.3.11"
    fm.vm.provision "puppet", type: "puppet", facter: {
      "vagrant_nodetype" => "foreman"
    }
  end

  config.vm.define :puppet do |pm|
    pm.vm.hostname = "puppet.example.net"
    pm.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    pm.vm.network "private_network", ip: "10.10.3.10"
    pm.vm.provision "puppet", type: "puppet", facter: {
      "vagrant_nodetype" => "puppetmaster"
    }
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.provision "puppet", type: "puppet" do |puppet|
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.working_directory = "/vagrant/puppet"
    puppet.facter = {
      "vagrant" => true
    }
  end

end
