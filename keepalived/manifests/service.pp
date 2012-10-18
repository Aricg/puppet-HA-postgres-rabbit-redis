##############################################################
# @filename : service.pp
##############################################################
#
# Class: keepalived::service
# 
#
#
# Parameters:
#
# None
#
# ==Actions
# - Enables and ensures that the keepalived Service is running
# - Defines what actions puppt can take to restart keepalived
#
# ==Requires
# Class['keepalived::install'] 
#
# ==Usage
# Sample Usage:
# include keepalived::service
#
# Class: keepalived::service
#
class keepalived::service(
  $service_name = 'keepalived',
  $ensure='running',
  $enable='true',
) { Class['keepalived::scripts'] -> Class['keepalived::config'] -> Class['keepalived::service']

  service { $service_name:
    ensure     => $ensure,
    enable     => $enable,
    restart    => '/etc/init.d/keepalived reload',
    hasstatus  => false,
    hasrestart => true,
  }

}
