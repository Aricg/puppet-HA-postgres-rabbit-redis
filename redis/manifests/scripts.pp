##############################################################
# @filename : scripts.pp
##############################################################
#
# Class: redis::scripts
#
# This class manages a redis::scripts server
#
# Parameters:
#
# ==Actions
#
# ==Requires
#  { Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config']
#
# ==Usage
# Sample Node Usage
# Class: redis::scripts
#
#prereq's for redis to beable to overcommit memory
#
class redis::scripts 
{ Class['redis::repo'] -> Class['redis::install'] -> Class['redis::config'] -> Class['redis::limits'] -> Class['redis::scripts']
          file { '/etc/sysctl.d/overcommit.conf':
		ensure => file,
		content => "vm.overcommit_memory=1",
               }
          exec { "overcommit-memory":
		command => "sysctl vm.overcommit_memory=1",
		unless => "test `sysctl -n vm.overcommit_memory` = 1",
	}

}

