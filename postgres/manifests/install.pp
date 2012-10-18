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
# add repo for postgres 9.2
# install postgres 9.2
#
# ==Requires
#   This class is dependancy for the other classes 
#
# ==Usage
# include postgres::install
	class postgres::install(
$package_name = "postgresql-9.2",
){ Class['postgres::install'] -> Class['postgres::keys'] 


package { $package_name:                                  
	ensure => installed,                                   
	require => Package[ ["libpq-dev"],["libpq5"] ],  
}   

package { [ ["libpq-dev"],["libpq5"] ]:
        ensure => installed,
        require => file['/etc/apt/sources.list.d/postgres.list'],
}


exec { "add-pitti-gpg-key":
        command => "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8683D8A2",
        unless => "/usr/bin/apt-key list|/bin/grep -c Pitt",
}

        file {"/etc/apt/sources.list.d/postgres.list":
                ensure => present,
                content => "deb http://ppa.launchpad.net/pitti/postgresql/ubuntu precise main                 
deb-src http://ppa.launchpad.net/pitti/postgresql/ubuntu precise main ",
                notify => Exec[update-apt-cache],
                require => Exec["add-pitti-gpg-key"],
        }



}
