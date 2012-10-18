##############################################################
# @filename : service.pp
##############################################################
#
# Class: rabbit::service
#
# This class manages a rabbit::service server
#
# Parameters:
#
# ==Actions
# Ensures rabbit is running 
# adds rabbit to the startup
#
# ==Requires
# Class['rabbitmq::repo'] -> Class['rabbitmq::config'] -> Class['rabbitmq::limits'] ->  Class['rabbitmq::service'] 
#
# ==Usage
# Sample Node Usage
#include rabbitmq::service
#
class rabbitmq::service(
  $service_name = 'rabbitmq-server',
  $ensure='running',
  $enable='true',
){ Class['rabbitmq::repo'] -> Class['rabbitmq::config'] -> Class['rabbitmq::limits'] ->  Class['rabbitmq::service']
  service { $service_name:
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
  }

}
