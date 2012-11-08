##############################################################
# @filename : service.pp
##############################################################
#
# Class: redis::service
#
# This class manages a redis::service server
#
# Parameters:
#
# ==Actions
#
# ==Requires
#  { Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config']
#
# ==Usage
# Sample Node Usage
# Class: redis::service
#
#Has been set to enable false becasue keepalived is in charge of running and failing redis.
#This needs testing. start redis should not be defined if keep alived has failed over the redis master. Solution? make puppet die if the expected master is not the master? 
class redis::service(
  $service_name = 'redis-server',
  $ensure=NULL,
  $enable=NULL,
  $default_master_ip=NULL,
  $start_redis=NULL,
) { Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config'] ->  Class['redis::limits'] -> Class['redis::scripts'] -> Class['redis::service']  

  service { $service_name:
    ensure     	=> $ensure,
    enable     	=> $enable,
    start	=> $start_redis,
    hasstatus  	=> true,
    hasrestart 	=> false,
  }

}
