#!/usr/bin/env bash
# This bootstraps Puppet 4 on CentOS 7.x
# It has been tested on CentOS 7.0 64bit

set -e

REPO_URL="https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm"

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if [ -f /opt/puppetlabs/bin/puppet ]; then
  echo "Puppet is already installed."
  exit 0
fi

# Install Puppet Collection repositories
echo "Installing Puppet Collection repositories..."
rpm -Uvh "${REPO_URL}" > /dev/null

# Install Puppet
echo "Installing Puppet..."
yum install -y puppet-agent > /dev/null

echo "Puppet installed!"
