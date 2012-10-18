##############################################################
# @filename : init.pp
##############################################################
#
# Class: standardize_admin_environment
#
# This class manages common tools we expect on all machines
# This class also diables apparmor and selinux. as these machines are not yet ready to be hardened (we are testing)
#
# Actions:
#   Ensures the common admin tools are installed and running.
#   And that distro security features are disabled untill the box is ready to be hardnend
# TODO I'm not very happy with the centos version of this. 
class standardize_admin_environment{

class htop{
  package { htop:
    ensure => present
  }

}


if $operatingsystem == "CentOS"  {

		package { "screen": ensure => "installed" }
		package { "curl": ensure => "installed" }
		package { "traceroute": ensure => "installed" }
		package { "bash-completion": ensure => "installed" }
		package { "ntp": ensure => "installed" }
		exec { "setenforce permissive": command => "/usr/sbin/setenforce permissive" }
		exec { "setenforce permanent ": command => "/bin/sed -e s,enforcing,permissive,g -i /etc/selinux/config" }

 
                                  }

        else {

		package { "screen": ensure => "installed" }
		package { "curl": ensure => "installed" }
		package { "traceroute": ensure => "installed" }
		package { "bash-completion": ensure => "installed" }
		package { "ntp": ensure => "installed" }

                        exec { "remove apparmor from rc-d if running":
                                command => "/usr/sbin/update-rc.d -f apparmor remove",
                               onlyif => "/usr/sbin/apparmor_status | grep -c [1-9] > 1"
                             }


                        exec { "teardown apparmor if running":
                                command => "/etc/init.d/apparmor teardown",
                                onlyif => "/usr/sbin/apparmor_status | grep -c [1-9] > 1"
                             }  



  	     }

	    	 }

