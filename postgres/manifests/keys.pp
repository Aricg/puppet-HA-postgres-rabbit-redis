##############################################################
# @filename : keys.pp
##############################################################
#
# Class: postgres::keys
#
# This class manages the postgres ssh authorized_keys so that passwordless rsync and other commands can be setn between master and slave
#
# Parameters:
#
# None
#
# ==Actions
# Creates the directories /var/lib/postgresql/.ssh/ and /var/lib/postgresql/.ssh/authorizedkeys.d
# Creates ssh keys for the postgres users
# Exports the pubkey so that it is accessible on the other machines (master slave)
# Collects the exported variables (this means puppet must be run twice on both machines from both to have the exported public key
# Adds the pubkeys to both machines authorized_keys file
# Adds the custom fact $pgsshpubkey (see ./lib/)
#
# ==Requires
# Class['postgres::install']  
# Custom fact $pgsshpubkey
# ==Usage
# Sample Usage:
# include postgres::keys
#
# Class postgres:keys
class postgres::keys()
{ Class['postgres::install'] -> Class['postgres::keys']


            
        file { '/var/lib/postgresql/.ssh/authorizedkeys.d':
            ensure  => directory,
            owner   => 'postgres',
            group   => 'postgres',
            mode    => '0644',
            require => File["/var/lib/postgresql/.ssh/"],
        }   

        #Chicken and Egg problem.                                                                 

        File <<| tag == "pubkey" |>>

#DEFINE AND REALIZE
        @@file {
            "/var/lib/postgresql/.ssh/authorizedkeys.d/key-${hostname}":      content => $pgsshpubkey, #this is a custom fact, it cannot return untill postgres keys are generated 
                                                                        tag => "pubkey",
                                                                        require => File["/var/lib/postgresql/.ssh/authorizedkeys.d"],
									subscribe => Exec["Create ssh keys for postgres user"],
									
}

        file { '/var/lib/postgresql/.ssh/':
            ensure  => directory,
            owner   => 'postgres',
            group   => 'postgres',
            mode    => '0644',
        }


            exec { "Create ssh keys for postgres user":
                command => "ssh-keygen -b 1024 -N '' -f /var/lib/postgresql/.ssh/id_rsa -t rsa -q",
                user => 'postgres',
		creates => "/var/lib/postgresql/.ssh/id_rsa",
                #unless => "ls /var/lib/postgresql/.ssh/ | grep id_rsa",

#                require => Class["postgres::install"],
            }

    
            exec { "cat together the auth_keys file":
                command => "rm /var/lib/postgresql/.ssh/authorized_keys;
/bin/cat /var/lib/postgresql/.ssh/authorizedkeys.d/* > /var/lib/postgresql/.ssh/authorized_keys;",
		subscribe => File["/var/lib/postgresql/.ssh/authorizedkeys.d/key-${hostname}"],
#               onlyif => "ls /var/lib/postgresql/.ssh/authorizedkeys.d/* | grep -c key",
#               require => Exec ["Create ssh keys for postgres user"], #File["/var/lib/postgresql/.ssh/authorizedkeys.d/key-$fqdn"],
            }
            
        # StrictHostKeyChecking no
        file { 'ssh_config':
            ensure  => file,
            path    => '/etc/ssh/ssh_config',
            content => template("postgres/ssh_config.tpl"),
                    owner   => '0',
            group   => '0',
            mode    => '0644',

          }
}
