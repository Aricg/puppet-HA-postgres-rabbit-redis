# this class is not ready for prime time. leving it in as a vestigal organ. 
# Class: postgres::spawnslave
class postgres::spawnslave(
)inherits postgres::config{

#Not going to let puppet do this, puppet shouldn't be expected to be cluster aware. 

Class ['postgres::database::besdb']  -> Class['postgres::spawnslave'] 

#            exec { "Create slave database":
#                command => "/var/lib/postgresql/9.2/master_spawn_slave.bash $slave_ip $data_dir $archive_dir",
#                user => 'postgres',
#                unless => "/usr/bin/psql -At -c \'select * from pg_stat_replication\' | grep $slave_ip",
#            }

}
