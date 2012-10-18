##############################################################
# @filename : slave.pp
##############################################################
#
# Class: postgres::slave
#
# This class manages a postgres::slave server
#
# Parameters:
#
# Inherited see postgres::config
#
# ==Actions
#   Ensures that the trigger file is removed, as a slave should not have this file.
#   Ensures the recovery.conf file, witch defines replication parameters
#
# ==Requires
#   Class ['postgres::keys'] -> Class['postgres::config'] -> Class['postgres::service'] 
#
# ==Usage
# Class: postgres::slave
class postgres::slave(
$data_dir = $postgres::config::data_dir,
$master_ip = $postgres::config::master_ip,
$repluser = $postgres::config::repluser,
$replpass = $postgres::config::replpass,
$package_name = $postgres::config::package_name,
)inherits postgres::config{
Class ['postgres::keys'] -> Class['postgres::config'] -> Class['postgres::service'] -> Class['postgres::slave']

#failover ensure absent/present
file { 'trigger':
	ensure => absent,
	path => '/tmp/trigger_file',
	content => "",
}

file { 'recovery.conf':
    ensure  => file,
    path    => "${data_dir}/recovery.conf",
    content => template("postgres/slave_recovery.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0700',
  }


}

