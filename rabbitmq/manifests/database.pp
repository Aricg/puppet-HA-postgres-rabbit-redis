##############################################################
# @filename : database.pp
##############################################################
#
# Class: rabbit::database
#
# This class manages a rabbit::database server
#
# Parameters:
# ensure = NULL,
# rabbit_username = NULL,
# rabbit_password = NULL,
# rabbit_role = NULL,
#
# ==Actions
#
# ==Requires
#  Class['rabbitmq::repo'] -> Class['rabbitmq::config'] -> Class['rabbitmq::limits'] ->  Class['rabbitmq::service']
#
# ==Usage
# Sample Node Usage
#
# Add your own login
#class { "rabbitmq::database":
#        ensure => present,
#        rabbit_username => Admin,
#        rabbit_password => SoSecreteThatIthurts,
#        rabbit_role => administrator,
#}
#
# Remove the Guest Login
#class { "rabbitmq::database::guest":
#        ensure => absent,
#        rabbit_username => 'guest',
#}
#
#TODO this should use exported variables... its not pretty right now. 
#

class rabbitmq::database( 
$ensure = NULL, 
$rabbit_username = NULL,
$rabbit_password = NULL,
$rabbit_role = NULL,
){ Class['rabbitmq::repo'] -> Class['rabbitmq::config'] -> Class['rabbitmq::limits'] ->  Class['rabbitmq::service'] -> Class['rabbitmq::database']
 
    case $ensure {
        present: {
            exec { "Create $rabbit_username rabbitmq db":
                command => "rabbitmqctl add_user $rabbit_username $rabbit_password",
                user => 'root',
                unless => "rabbitmqctl list_users | grep '$rabbit_username'",
            }

 exec { "Grant $rabbit_username Admin":
                command => "rabbitmqctl set_user_tags $rabbit_username administrator",
                user => 'root',
                unless => "rabbitmqctl list_users | grep '$rabbit_username' | grep administrator",
                require => exec["Create $rabbit_username rabbitmq db"],
            }


        }
        absent: {
            exec { "Remove $rabbit_username rabbitmq db":
                command => "rabbitmqctl delete_user $rabbit_username",
                onlyif => "rabbitmqctl list_users  | grep '$rabbit_username'",
                user => 'root',
            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for rabbitmq::database"
        }
    }

}

class rabbitmq::database::guest(
$ensure = absent,
$rabbit_username = 'guest',
$rabbit_password = 'FeSLowDSpfdps',
$rabbit_role = 'administrator',
){ Class['rabbitmq::repo'] -> Class['rabbitmq::config'] -> Class['rabbitmq::limits'] ->  Class['rabbitmq::service'] -> Class['rabbitmq::database'] -> Class['rabbitmq::database::guest']
    case $ensure {
        present: {
            exec { "Create $rabbit_username rabbitmq db":
                command => "rabbitmqctl add_user $rabbit_username $rabbit_password",
                user => 'root',
                unless => "rabbitmqctl list_users | grep '$rabbit_username'",
            }
        }
        absent: {
            exec { "Remove $rabbit_username rabbitmq db":
                command => "rabbitmqctl delete_user $rabbit_username",
                onlyif => "rabbitmqctl list_users  | grep '$rabbit_username'",
                user => 'root',
            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for rabbitmq::database"
        }
    }
}





