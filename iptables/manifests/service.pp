##############################################################
# @filename : service.pp
##############################################################
#
# Class: iptables::service
# 
#
#
# Parameters:
#
# None
#
# ==Actions
# - Enables and ensures that a CentOS like iptables Service is running
# - Defines what actions puppt can take to restart iptables
#
# ==Requires
# Class['iptables::install'] 
#
# ==Usage
# Sample Usage:
# include iptables::service
#
# Class iptables::service

class iptables::service(
  $ensure='running',
  $service_name = 'iptables-persistent',
  $enable='true',
) { Class['iptables::install'] -> Class['iptables::service']

  service { $service_name:
    ensure     	=> $ensure,
    enable     	=> $enable,
    restart 	=> '/etc/init.d/iptables-persistent reload',
    hasstatus  	=> false,
    hasrestart 	=> true,

  }

}
