##############################################################
# @filename : repo.pp
##############################################################
#
# Class: postgres::repo
#
# This class installs the  postgres 9.2 server's repo
#
# Parameters:
#
# ==Actions
# install dependancies for postgres
# add repo for postgres 9.2
#
# ==Requires
#   This class is dependancy for the other classes 
#
# ==Usage
# include postgres::repo
	class postgres::repo(
){

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
