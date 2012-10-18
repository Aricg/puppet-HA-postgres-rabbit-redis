##############################################################
# @filename : limits.pp
##############################################################
#
# Class: redis::limits
#
# This class manages a redis::limits server
#
# Parameters:
#
# ==Actions
#  allows redis may to open more that 1024 files. but this is just a precuation we have not tested under load yet
#
# ==Requires
#  { Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config'] 
#
# ==Usage
# Sample Node Usage
# Class: redis::limits
#
class redis::limits 
{ Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config'] -> Class['redis::limits']
file { '/etc/default/redis-server':
    ensure  => file,
    path    => '/etc/default/redis-server',
    content => "ULIMIT=65536",
    owner   => 'redis',
    group   => 'redis',
    mode    => '0644',
  }

}

