##############################################################
# @filename : limits.pp
##############################################################
#
# Class: rabbit::limits
#
# This class manages rabbit::limits 
#
# Parameters:

# - the ulimit sets how many file descriptors are avaliable to rabbit. Erlang likes file descriptors, feed it. 
#
# ==Actions
#
# ==Requires
# Class['rabbitmq::repo'] -> Class['rabbitmq::config'] 
# ==Usage
# Sample Node Usage
# Class: rabbit::service
#
#increase the file discriptors availiable to rabbitmq
class rabbitmq::limits( 
$ulimit = 65330,
){ Class['rabbitmq::repo'] -> Class['rabbitmq::config'] -> Class['rabbitmq::limits'] 

      file { "/etc/default/rabbitmq-server":
                mode => "644",
                content => template("rabbitmq/rabbitmq-limits"),
                notify  => Service['rabbitmq-server'],
        }



}

