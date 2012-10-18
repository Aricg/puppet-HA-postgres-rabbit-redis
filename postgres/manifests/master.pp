##############################################################
# @filename : master.pp
##############################################################
#
# Class: postgres::master
#
# This class manages a postgres::master server
#
# Parameters:
#
# Inherited see postgres::config
#
# ==Actions
#   Ensures that the trigger file is present, as a master should have this file.
#   Ensures the recovery.conf is called recovery.done, witch defines but makes inactive the replication parameters
#   Drops all the databases, and recreates the intial template a UTF8. This is an evil thing to do in a script See todo
#
# ==Requires
#   Class['postgres::service']
#
# ==Usage
# Class: postgres::master
# TODO make the drop cluster utf8 bit not evil
class postgres::master(
$data_dir = $postgres::config::data_dir,
$conf_dir = $postgres::config::conf_dir,
$master_ip = $postgres::config::master_ip,
$slave_ip = $postgres::config::slave_ip,
$app_server1 = $postgres::config::app_config1,
$app_server2 = $postgres::config::app_config2,
$test_server1 = $postgres::config::test_config1,
$repluser = $postgres::config::repluser,
$replpass = $postgres::config::replpass,
$besuser = $postgres::config::besuser,
$bespass = $postgres::config::bespass,
)inherits postgres::config{

Class['postgres::service'] -> Class['postgres::master'] 

file { 'trigger':
        ensure => present,
        path => '/tmp/trigger_file',
        content => "",
}


file { 'recovery.conf':
    ensure  => file,
    path    => "${data_dir}/recovery.done",
    content => template("postgres/master_recovery.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0644',
  }

           exec { "Rebuild Base DB UTF8":
               command => 	"touch /tmp/dont_fail_over;
				/etc/init.d/postgresql stop;
				pg_dropcluster 9.2 main; 
				pg_createcluster -e UTF8 9.2 main;
				/etc/init.d/postgresql start;
				rm /tmp/dont_fail_over;",
              user => 'postgres',
              unless => "psql -At -c \'show client_encoding\' | grep UTF8",
          }


}
