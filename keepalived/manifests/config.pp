##############################################################
# @filename : config.pp
##############################################################
#
# Class: keepalived::config
#
#
# Parameters:
# - the $priority is a number that defines who should be the master (higher is master)
# - the $postgres_vip is the ipaddress that will failover ensuring a connection to the postgres master
# - the $redis_vip   is the ipaddress that will failover ensuring a connection to the redis master
# - the $state is the intial state keepalived tries to start as (MASTER or BACKUP)
# - the $prempt decides if a failed over machine should return to its original position if the original master returns. (generally we dont want this)
# - the $master_ip is the ipaddress of the original master machine
# - the $slave_of_ip this is the ip of the opposite machine so that if redis decides it should be a slave it can correctly guess the master ip. 
# - the $slave_ip = N is the ipaddress of the original slave machin,
#
#
# None
#
# ==Actions
# - Ensures that the main config file and custom postgres health check for keepalived are present
# ==Requires
# Class['keepalived::scripts']
# ==Usage
# Sample Usage (master):
#class {"keepalived::config":
#                priority => '150',
#                postgres_vip => $pg_vip,
#                redis_vip  => $redis_vip,
#                state => 'MASTER',
#                prempt => 'nopreempt',
#                master_ip => $default_master_ip,
#                slave_of_ip => $default_slave_ip,
#                slave_ip => $default_slave_ip,
#}
#
#
# Class keepalived::config
class keepalived::config(
$priority = NULL,
$postgres_vip = NULL,
$redis_vip  = NULL,
$state = NULL,
$prempt = NULL,
$master_ip = NULL,
$slave_of_ip = NULL,
$slave_ip = NULL,


) { Class['keepalived::scripts'] -> Class['keepalived::config'] 

  package { 'keepalived':
    ensure => installed,
    notify => Class['keepalived::service'],
  }


file { 'keepalived.config':
    ensure  => file,
    path    => '/etc/keepalived/keepalived.conf',
    content => template("${module_name}/keepalived.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['keepalived::service'],
    require => Package['keepalived'],
  }

file { 'check_postgres':
    ensure  => file,
    path    => '/usr/sbin/check_postgres',
    content => template("${module_name}/check_postgres.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => Package['keepalived'],
  }



} 
