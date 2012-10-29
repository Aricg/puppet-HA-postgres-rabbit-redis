##############################################################
# @filename : service.pp
##############################################################
#
# Class: postgres:service
#
# This class manages a postgres:service server
#
# Parameters:
# - The $ensure puppet will start postgres if it is stopped
# - The $enable whether this service should be run at astartup
#
# ==Requires
#  Class['postgres::config']  
#
# ==Usage
# Sample Usage:
#class {"postgres::service":
#        ensure=> 'running', #Valid values are stopped, running.
#        enable=> 'true', #this doesnt seem to do anything
#}
 
# Class: postgres::service
class postgres::service(
  $ensure='running',
  $enable='true',
) {

Class['postgres::config'] -> Class['postgres::service']  
  service { 'postgresql':
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => true,
    hasreload => true,
  }
}
