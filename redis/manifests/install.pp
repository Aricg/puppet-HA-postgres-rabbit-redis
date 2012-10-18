##############################################################
# @filename : install.pp
##############################################################
#
# Class: redis::install
#
# This class installs redi server
#
# Parameters:
# - the  $package_name would generally be 'redis-server',
# - the  $service_name would also genearlly be 'redis-server',
# - the  $bind_address would be defined by your interface EG:$::ipaddress_eth1, or 0.0.0.0
#
# ==Actions
#
# ==Requires
#  { Class['redis::repo']
#
# ==Usage
# Sample Node Usage
#include redis::install
#
#
class redis::install(
  $package_name = 'redis-server',
  $service_name = 'redis-server',
  $bind_address = 'NULL',
) { Class['redis::repo'] -> Class['redis::install']


  package { $package_name:
    ensure => installed,
    notify => Class['redis::service'],
    require => file['/etc/apt/sources.list.d/dotdeb.list'],
  }

package { [ ["dialog"],["rcconf"] ]:
    ensure => installed,

}
}
