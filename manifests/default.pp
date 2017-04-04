#
# Node Classifier
# Select a single role for the node to perform.
#

#include "profiles::base" Puppet, Ruby, etc

# Example of a logic-based classifer
# $::role = $facts['hostname']
# or in our case a fact-based classifer. The fact being is supplied to Puppet by Vagrant, see Vagrantfile.
#include "roles::${::role}"

notify { "Role injected: ${::role}": }