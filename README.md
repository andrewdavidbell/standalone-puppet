# Standalone Puppet Reference Implementation

#### Table of Contents

1. [Description](#description)
1. [Development environment](#development-environment)
    * [Vagrant](#vagrant)
1. [Puppet](#puppet)
    * [Preferred Programming Style](#preferred-programming-style)
    * [Node Configuration](#node-configuration)

## Description

An example of a standalone Puppet deployment (masterless).

The following nodes are provisioned:
* Standard Operating Environment (SOE)
* Puppet Inventory and Management Console
    * PuppetDB
    * PuppetExplorer

The SOE demonstrates a Puppet configuration being applied to a node at reqular intervals and its catalog, facts, and reports being posted to an node inventory.


## Development environment

* Puppet nodes implemented by CentOS Linux Virtual Machines
* Vagrant used to manage VMs and provision initial Puppet configuration
* puppet-lint gem installed on development host
    * invoked by IDE plugin
* bundler used to install Puppet gem on macOS development host
    * bundle config specific_platform true
    * bundle install --path vendor
    * echo 'vendor/ruby' >> .gitignore
    * bundle package

### Vagrant

* Provisioning
    * Puppet 4 installed using shell provisioner
    * Node configured using Puppet Apply provisioner
        * Used defaults where possible
        * Puppet manifest, modules, and hiera configuration copied to VM
* Networking
    * Private Network
        * All instances on same subnet
    * A specific IP address is required to support NFS because [DHCP won't work.](http://stackoverflow.com/questions/39354221/how-to-set-up-a-shared-vagrant-directory-on-an-osx-vagrant-box)
Also, to prevent another VirtualBox Adapter being created the address assigned is in range of the DHCP server of VirtualBox Host-only Adapter.
    * Application ports also forwarded for convenience
* Synced Folders
    * NFS shared directories (Private Network required)
        * This seems to be the most reliable mechanism on macOS
    * Hiera data shared into VM via /vagrant Synced Folder
* Multi-machine example
    * Backed by VirtualBox and Digital Ocean
    * ssh ports overridden


## Puppet

* Fact-based node classifier with example of logic-based classifier too.
* Roles and Profiles design pattern observed
* Third-party modules installed using 'puppet module install'
* Hiera configuration uses an absolute directory to allow the hiera CLI to work from any directory

### Preferred Programming Style

* Interfacing with subclasses
    * Passing data via parameterized class declarations
        * Class declaration and *contain* function call
    * Puppet elements documented using Puppet Strings

### Node configuration

* Ruby environment
    * chruby - manage ruby versions
    * ruby-install - install rubies
    * Bundler - manage gem installation
    * Rake - ruby tasks
