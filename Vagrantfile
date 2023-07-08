# -*- mode: ruby -*-
# vi: set ft=ruby :

%w(vagrant-vbguest).each do |plugin|
  fail "Please install the '#{plugin}' plugin" unless Vagrant.has_plugin?(plugin)
end

def configure_provisioner(config, facts = nil)
  config.vm.provision "puppet" do |puppet|
    puppet.synced_folder_type = "nfs"
    # defaults...
    puppet.manifest_file      = "default.pp"
    puppet.manifests_path     = "manifests"
    # puppet.module_path        = "modules"
    puppet.environment        = "production"
    puppet.environment_path   = "./"
    puppet.hiera_config_path  = "hiera.yaml"
    # Required for relative path in Hiera configuration
    # but we're using an absolute path so that a CLI hiera
    # request can be ran from any directory.
    # puppet.working_directory  = "/vagrant"
    puppet.options            = "--verbose --debug" #--debug

    # Inject facts into instance for the node classifier
    if facts then
      puppet.facter = facts
    end
  end
end

Vagrant.configure("2") do |config|

  # Locally host Centos 7 box with Guest Additions applied
  config.vm.box  = "centos-guestadd/7"

  # Private Networks are required to support NFS shared folders
  # Whilst IP addresses can be used, ports have been forwarded for convenience.

  config.vm.define "asset" do |ast|
    ast.vm.hostname = "asset.example.com"
    ast.vm.network "private_network", ip: "172.28.128.4"
    ast.vm.network "forwarded_port", guest: 22, host: 2210, id: 'ssh'

    #configure_provisioner ast, { "role" => "soe" }
  end

  config.vm.define "inventory" do |inv|
    inv.vm.hostname = "inventory.example.com"
    inv.vm.network "private_network", ip: "172.28.128.5"
    inv.vm.network "forwarded_port", guest: 22, host: 2220, id: 'ssh'
    # Puppet Explorer
    inv.vm.network "forwarded_port", guest: 443, host: 4433

    configure_provisioner inv, { "role" => "inventory" }
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus   = 1
  end

  config.vm.provider "digital_ocean" do |digocn, override|
    override.ssh.private_key_path = "~/.ssh/digital_ocean"

    digocn.token  = ENV['DIGITAL_OCEAN_TOKEN']
    digocn.image  = "centos-7-0-x64"
    digocn.region = "sgp1"
  end

  # Install Puppet Agent onto guest box using Shell Provisioner
  config.vm.provision "shell", path: "centos_7_x.sh"

  config.vm.synced_folder ".", "/vagrant", type: "nfs"

end
