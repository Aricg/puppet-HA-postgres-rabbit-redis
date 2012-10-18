##############################################################
# @filename : config.pp
##############################################################
#
# Class: redis::config
#
# This class manages basic redis configs
#
# Parameters:
#
# ==Actions
#  Ensures that  custom init file and redis config file are in place
# ==Requires
#  { Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config']
#
# ==Usage
# Sample Node Usage
#include redis::config
# 
#
class redis::config(
) { Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config'] 


file { 'redis.conf':
    ensure  => file,
    path    => '/etc/redis/redis.conf',
    content => template("redis/redis.conf"),
    owner   => 'redis',
    group   => 'redis',
    mode    => '0644',
    notify  => Class['redis::service'],
  }

file { 'redis init file':
    ensure  => file,
    path    => '/etc/init.d/redis-server',
    content => template("redis/redis-server"),
    owner   => 'redis',
    group   => 'redis',
    mode    => '0744',
  }


}
