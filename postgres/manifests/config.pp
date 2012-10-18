##############################################################
# @filename : config.pp
##############################################################
#
# Class: postgres::config
#
# This class manages a postgres::config server
#
# Parameters:
#
# - the $package_name for postgres server
# - the $service_name for postgres server
# - the $service_ensure for whether puppet should start or stop postgres if it is running
# - the $data_dir that postgres is to use
# - the $conf_dir that postgres is to use
# - the $archive_dir that postgres should save its wal archives to
# - the $master_ip which machine will originally besetup as the master postgres server
# - the $slave_ip  which machine will originally besetup as the slave (replicant) postgres server
# - the $app_server1 first application server which is allowed to connect
# - the $app_server2 second application server which is allowed to connect
# - the $repluser is the replicants username, generally replication
# - the $replpass is the replicant users password
# - the $besuser is the master application user
# - the $bespass the password for the master application user
# - the $test_server1 is another server that is given limited access to the database, perhaps a developer desktop
# - the $pg_db1-4 are databases that you can define, they will becreated for you. 
# ==Actions
#   Ensures that the trigger file is removed, as a slave should not have this file.
#   Ensures the recovery.conf file, witch defines replication parameters
#
# ==Requires
#   Class ['postgres::keys'] 
#
# ==Usage
# Sample Usage:
# class {"postgres::config":
#         $package_name => $pg_package_name,
#         $service_name => $pg_service_name,
#         $service_ensure => $pg_service_ensure,
#         $data_dir => $pg_data_dir,
#         $conf_dir => $pg_conf_dir,
#         $archive_dir => $pg_archive_dir,
#         $master_ip => $default_master_ip,
#         $slave_ip => $default_slave_ip,
#         $app_server1 => $pg_app_server1,
#         $app_server2 => $pg_app_server2,
#         $repluser => $pg_repluser,
#         $replpass => $pg_replpass,
#         $besuser => $pg_besuser,
#         $bespass => $pg_bespass,
#         $test_server1 => $pg_test_server1,
#	  $pg_db1 = users,
#	  $pg_db2 = shopping,
#	  $pg_db3 = cars,
#	  $pg_db4 = boats,
#
# }
# I dont know how clear this is so. you need to create values higher up in the scope to match pg_package name and the ilk IE:
# node postgrescluster_shared {
# $pg_package_name = 'postgresql-9.2'
# $pg_service_name = 'postgresql'
# $pg_service_ensure = 'running'
# $pg_data_dir = "/var/lib/postgresql/9.2/main/"
# $pg_conf_dir = "/etc/postgresql/9.2/main/"
# $pg_archive_dir = "/var/lib/postgresql/9.2/archive/"
# $default_master_ip = '10.x.x.x'
# $default_slave_ip = '10.x.x.x'
# $pg_app_server1 = '10.x.x.x'
# $pg_app_server2 = '10.x.x.x'
# $pg_repluser = 'replication'
# $pg_replpass = 'xxxxxxxxxx'
# $pg_besuser = 'foo'
# $pg_bespass = 'xxxxxxxxxxxx'
# $pg_test_server1 = 'x.x.x.x'
# $pg_vip = 'x.x.x.x'
# $redis_vip  = 'x.x.x.x'
# $rabbit_user = 'foouser'
# $rabbit_pass = 'xxxxxxxx'
# $rabbit_login = 'fooadmin'
# $rabbit_stage = 'rabbit@foonetx
# $rabbit_node1 = 'rabbit@foonetx'
# $rabbit_node2 = 'rabbit@foonety'
# $pg_db1 = "users"
# $pg_db2 = "shopping"
# $pg_db3 = "cars"
# $pg_db4 = "boats"

##
class postgres::config(
$data_dir = NULL,
$archive_dir = NULL,
$conf_dir = NULL,
$package_name = NULL,
$master_ip = NULL,
$slave_ip = NULL,
$repluser = NULL,
$replpass= NULL,
$app_server1 = NULL,
$app_server2 = NULL,
$test_server1 = NULL,
$pg_user = NULL,
$pg_pass = NULL,
$pg_db1 = NULL,
$pg_db2 = NULL,
$pg_db3 = NULL,
$pg_db4 = NULL,
$service_ensure = NULL,
$service_name = NULL,
){
Class['postgres::keys'] -> Class['postgres::config']


file { '/var/lib/postgresql/9.2/archive/':
    ensure  => directory,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0644',
  }

file { '/var/lib/postgresql/9.2/masterarchive/':
    ensure  => directory,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0644',
  }


file { '/var/lib/postgresql/9.2/main/':
    ensure  => directory,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0700',
  }



file { '/var/lib/postgresql/.psql_history':
    ensure  => present,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0644',
  }


file { 'postgresql.conf':
    ensure  => file,
    path    => "${conf_dir}/postgresql.conf",
    content => template("postgres/postgresql.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0644',
    notify => Service[$service_name],
  }

file { 'pg_hba.conf':
    ensure  => file,
    path    => "${conf_dir}/pg_hba.conf",
    content => template("postgres/pg_hba.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0640',
  }

file { 'master_spawn_slave.bash':
    ensure  => present,
    path    => '/var/lib/postgresql/9.2/master_spawn_slave.bash',
    content => template("postgres/master_spawn_slave.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0744',
  }

file { 'slave_spawn_from_master':
    ensure  => present,
    path    => '/var/lib/postgresql/9.2/slave_spawn_from_master.bash',
    content => template("postgres/slave_spawn_from_master.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0744',
  }

file { 'promote_slave.erb':
    ensure  => present,
    path    => '/var/lib/postgresql/9.2/promote_slave',
    content => template("postgres/promote_slave.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0744',
  }


}

