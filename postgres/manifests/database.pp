##############################################################
# @filename : database.pp
##############################################################
#
# Class: postgres::database
#
# This class manages a postgres::database server
#
# Parameters:
# - inherited from (must be defined in) postgres::config
#
# ==Actions
#  Creates four postgres databases owned by a user from the postgres:user class
#  
#
# ==Requires
#  Class ['postgres::master'] -> Class ['postgres::user'] # only try to create database on the master node after users have been created 
#
# ==Usage
# Sample Node Usage
#include postgres::database
#
#realize(        Postgres::Database::Postgres_database["cars"],
#                Postgres::Database::Postgres_database["boats"],
#                Postgres::Database::Postgres_database["trucks"],
#                Postgres::Database::Postgres_database["helicopters"], )
class postgres::database(
$db_owner = $postgres::config::pg_user,
$pg_db1 = $postgres::config::pg_db1,
$pg_db2 = $postgres::config::pg_db2,
$pg_db3 = $postgres::config::pg_db3,
$pg_db4 = $postgres::config::pg_db4,
)inherits postgres::config
{ Class ['postgres::master'] -> Class ['postgres::user']
            

		define postgres_database( $name, $owner, $pg_db_name )
		{	
		exec { $name:
        	        command => "/usr/bin/createdb -O $owner $pg_db_name",
                	user => 'postgres',
	                unless => "/usr/bin/psql -l | grep '$pg_db_name *|'",
        	    }
}

@postgres_database { $pg_db1:
name => $pg_db1,
owner => $db_owner,
pg_db_name => $pg_db1,
}

@postgres_database { $pg_db2:
name => $pg_db2,
owner => $db_owner,
pg_db_name => $pg_db2,
}

@postgres_database { $pg_db3:
name => $pg_db3,
owner => $db_owner,
pg_db_name => $pg_db3,
}

@postgres_database { $pg_db4:
name => $pg_db4,
owner => $db_owner,
pg_db_name => $pg_db4,
}

}
