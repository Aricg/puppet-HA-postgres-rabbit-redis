##############################################################
# @filename : repo.pp
##############################################################
#
# Class: rabbit::repo
#
# This class manages a rabbit::repo server
#
# Parameters:
#
# ==Actions
# Adds rabbits very own debian repo
# Adds the proper signing keing
# Updates aptitude
# ==Requires
#  All rabbit classes depend on this repo being present
#
# ==Usage
# Sample Node Usage
# include rabbitmq::repo
 
class rabbitmq::repo
{

exec { "add-rabbit-gpg-key":
        command => "/usr/bin/wget -q http://www.rabbitmq.com/rabbitmq-signing-key-public.asc -O -|/usr/bin/apt-key add -",
        unless => "/usr/bin/apt-key list|/bin/grep -c rabbitmq",
}

        file {"/etc/apt/sources.list.d/rabbitmq.list":
                ensure 	=> present,
                require => Exec["add-rabbit-gpg-key"],
                content => "deb http://www.rabbitmq.com/debian/ testing main",
                notify 	=> Exec[update-apt-cache]
        }




}
