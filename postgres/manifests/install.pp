##############################################################
# @filename : install.pp
##############################################################
#
# Class: postgres::install
#
# This class install postgres 9.2 server
#
# Parameters:
#
# ==Actions
# install dependancies for postgres
# install postgres 9.2
#
# ==Requires
#   This class is dependancy for the other classes 
#
# ==Usage
# include postgres::install
	class postgres::install(
$package_name = "postgresql-9.2",
){ Class ['Postgres::Repo'] -> Class['postgres::install'] 


package { $package_name:                                  
	ensure => installed,                                   
	require => Package[ ["libpq-dev"],["libpq5"], ["postgresql-contrib-9.2"] ],  
}   

package { [ ["libpq-dev"],["libpq5"], ["postgresql-contrib-9.2"] ]:
        ensure => installed,
        require => File['/etc/apt/sources.list.d/postgres.list'],
}


}
