##############################################################
# @filename : repo.pp
##############################################################
#
# Class: redis::repo
#
# This class manages a redis::repo server
#
# Parameters:
#
# ==Actions
#
# ==Requires
#
# ==Usage
# Sample Node Usage
# Class: redis::repo
#
class redis::repo
{
exec { "add-dotdeb-gpg-key":
        command => "/usr/bin/wget -q wget http://www.dotdeb.org/dotdeb.gpg -O -|/usr/bin/apt-key add -",
        unless => "/usr/bin/apt-key list|/bin/grep -c dotdeb",
}
        file {"/etc/apt/sources.list.d/dotdeb.list":
                ensure => present,
                require => Exec["add-dotdeb-gpg-key"],
                content => "deb http://packages.dotdeb.org stable all  
deb-src http://packages.dotdeb.org stable all",
               notify => Exec[update-apt-cache]
        }
exec { "update-apt-cache":
	command => "/usr/bin/apt-get update",
	onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
	}
}
