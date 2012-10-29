##############################################################
# @filename : install.pp
##############################################################
#
# Class: rabbit::install
#
# This class install rabbitmq-server
#
# Parameters:
# - the pkg_ensure tells pupppet to ensure that the package is installed
# ==Actions
#
# ==Requires
# Class['rabbitmq::rinstall'] 
#
# ==Usage
# Sample Node Usage
#class { "rabbitmq::install":
#        pkg_ensure  => 'present',
#}
class rabbitmq::install(
  $pkg_ensure  = 'present',
) { Class['rabbitmq::repo'] -> Class['rabbitmq::install']
 

  package { 'rabbitmq-server':
    ensure => $pkg_ensure,
  }
}
