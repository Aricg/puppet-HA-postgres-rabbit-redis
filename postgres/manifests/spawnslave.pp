# this class is not ready for prime time. leving it in as a vestigal organ. 
# Class: postgres::spawnslave
class postgres::spawnslave(
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

#Not going to let puppet do this, puppet shouldn't be expected to be cluster aware. 

Class ['postgres::database::besdb']  -> Class['postgres::spawnslave'] 

#            exec { "Create slave database":
#                command => "/var/lib/postgresql/9.2/master_spawn_slave.bash $slave_ip $data_dir $archive_dir",
#                user => 'postgres',
#                unless => "/usr/bin/psql -At -c \'select * from pg_stat_replication\' | grep $slave_ip",
#            }

}
