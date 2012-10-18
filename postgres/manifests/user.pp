##############################################################
# @filename : user.pp
##############################################################
#
# Class: postgres::user
#
# This class manages a postgres::user server
#
# Parameters:
#
# - inherited from (must be defined in) postgres::config
#
# ==Actions
# creates two roles, one for replication, and one a user with login and create database priv
#  
#
# ==Requires
# Class['postgres::master'] #only try to create users on the masterdb 
#
# ==Usage 
#
# Sample Node Usage:
#include postgres::user
#realize(        Postgres::User::Postgres_user["replication"],
#                Postgres::User::Postgres_user["foo"], )
#
#

class postgres::user(
$repluser = $postgres::config::pg_repluser,
$replpass = $postgres::config::pg_replpass,
$pg_user = $postgres::config::pg_user,
$pg_pass = $postgres::config::pg_pass,
) inherits postgres::config
{ Class['postgres::master'] -> Class['postgres::user']

	define postgres_user( $name, $grants, $password ) 
	{
            exec { $name:
                command => "/usr/bin/psql -c \"CREATE ROLE $name $grants PASSWORD $password\"",
                user => 'postgres',
                unless => "/usr/bin/psql -c '\\du' | grep '^ *$name *|'",
            }
}

@postgres_user { $repluser:
name => $repluser,
grants => "REPLICATION LOGIN",
password => "'${replpass}'",
}

@postgres_user { $pg_user:
name => $pg_user,
grants => "CREATEDB LOGIN",
password => "'${pg_pass}'",

}
}
