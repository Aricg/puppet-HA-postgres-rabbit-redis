#######################################################
# This Class sets up automatic security updates Works for Centos or Ubuntu/debian
#
# ==Actions 
# Sets up automatic security updates, works for centos and ubuntu
#
# ==Requires 
# 
# * Package["yum-security"]
# * File["20auto-upgrades"],
#
# * File["50unattended-upgrades"] 
#
# I dont trust sysadmins to actually apply sercurity updates. So I make it automatic. 
#######################################################

class auto_update_security {


  case $operatingsystem { centos: { include auto_update_security::centos }
                   Debian,Ubuntu: { include auto_update_security::ubuntu }
                         default: { fail("${hostname}: This module does not support operatingsystem $operatingsystem") }
                        }

                 }

class auto_update_security::centos{

                package { "yum-security": ensure => "installed" }

				    file { "/etc/cron.daily/yumupdatesecurity":
					owner   => root,
					group   => root,
					mode    => 440,
					source  => "puppet:///modules/auto_update_security/yum-security-cron",
					require => Package["yum-security"],
					 }



                                  }

class auto_update_security::ubuntu{

		file {"20auto-upgrades":
			   path => "/etc/apt/apt.conf.d/20auto-upgrades",
			   ensure => present,
			   content => template("auto_update_security/20auto-upgrades")
		     }

		file {"50unattended-upgrades":
			   path => "/etc/apt/apt.conf.d/50unattended-upgrades",
			   ensure => present,
			   content => template("auto_update_security/50unattended-upgrades")
		     }


		package { unattended-upgrades: ensure => present,
			  require => [ File["20auto-upgrades"], File["50unattended-upgrades"] ]
	             }


	      }



