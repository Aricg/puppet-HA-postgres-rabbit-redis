# Fact: ssh
#
# Purpose:
#
# Resolution:
#
# Caveats:
#

## ssh.rb
## Facts related to SSH
##

    Facter.add("sshpostgres") do
      setcode do
	    Facter::Util::Resolution.exec("cat /var/lib/postgresql/.ssh/id_rsa.pub")
          end
        end

