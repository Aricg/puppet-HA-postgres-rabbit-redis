##############################################################
# @filename : install.pp
##############################################################
#
# Class: iptables::install
#
#
# Parameters:
#
# None
#
# ==Actions
# - Install a CentOS like iptables init-script
# - Ensures a rules file which blocks everything on the public interface
# ==Requires
#
# ==Usage
# Sample Usage:
# include iptables::install
#
# Class iptables::install

class iptables::install(
) {

#must bind to local interface
package {"make ip tables centos-ish":
        ensure  => installed,
        name	=> "iptables-persistent",
}


file { '/etc/iptables/rules.v4':
   content => template("iptables/iptables"),
   notify => Service["iptables-persistent"],
   require => Package['make ip tables centos-ish'],
  }



}
