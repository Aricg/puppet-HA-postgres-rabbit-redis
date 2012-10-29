##############################################################
# @filename : config.pp
##############################################################
#
# Class: rabbit::config
#
# This class manages a rabbit::config server
#
# Parameters:
# - the port defines the port the rabbit service should run on
# - the secret is the key shared between rabbit servers to secure their transactions
# - the service_ensure ensures whether rabbit will run on startup
# - the pkg_ensure tells pupppet to ensure that the package is installed
# - the multiple_nodes must be set to yes or no based on how many nodes you have
# - the node1 full rabbit name for multi node env
# - the node2 second full rabbit name for multi node env
# - the node_stage is for single node environments
#
#
# ==Actions
#
# ==Requires
# Class['rabbitmq::repo'] 
#
# ==Usage
# Sample Node Usage
#class { "rabbitmq::config":
#        multiple_nodes => 'yes',
#        port => 5672,
#        secret => 'PASSWORD',
#        node1 => rabbit@foonet01.local,
#        node2 => rabbit@foonet02.local,
#
#}

#
class rabbitmq::config(
  $port = '5672',
  $secret = NULL,
  $service_ensure = 'running',
  $pkg_ensure  = 'present',
  $multiple_nodes = NULL,
  $node1 = NULL,
  $node2 = NULL,
  $node_stage = NULL,

) { Class['rabbitmq::repo'] -> Class['rabbitmq::config']
 

  package { 'rabbitmq-server':
    ensure => $pkg_ensure,
  }

file { '/etc/rabbitmq':
    ensure  => directory,
    owner   => 'rabbitmq',
    group   => 'rabbitmq',
    mode    => '0644',
    require => Package['rabbitmq-server'],
  }


    case $multiple_nodes {
        yes: {

			file { 'rabbitmq.config':
			    ensure  => file,
			    path    => '/etc/rabbitmq/rabbitmq.config',
			    content => template("${module_name}/rabbitmq.config"),
			    owner   => 'rabbitmq',
			    group   => 'rabbitmq',
			    mode    => '0644',
			    notify  => Class['rabbitmq::service'],
    			    require => Package['rabbitmq-server'],
			  }

				    }

	no: {
			file { 'rabbitmq.config.stage':
			    ensure  => file,
			    path    => '/etc/rabbitmq/rabbitmq.config',
			    content => template("${module_name}/rabbitmq.config.stage"),
			    owner   => 'rabbitmq',
			    group   => 'rabbitmq',
			    mode    => '0644',
			    notify  => Class['rabbitmq::service'],
    			    require => Package['rabbitmq-server'],
			  }
				    }

}


file { 'enabled_plugins':
    ensure  => file,
    path    => '/etc/rabbitmq/enabled_plugins',
    content => template("${module_name}/enabled_plugins"),
    owner   => 'rabbitmq',
    group   => 'rabbitmq',
    mode    => '0644',
    notify  => Class['rabbitmq::service'],
    require => Package['rabbitmq-server'],
  }

file { 'rabbitmq-env.config':
    ensure  => file,
    path    => '/etc/rabbitmq/rabbitmq-env.conf',
    content =>  template("${module_name}/rabbitmq-env.conf.erb"),
    owner   => 'rabbitmq',
    group   => 'rabbitmq',
    mode    => '0644',
    notify  => Class['rabbitmq::service'],
    require => Package['rabbitmq-server'],
  }

}
