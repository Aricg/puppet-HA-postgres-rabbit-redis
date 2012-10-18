# pgsshpubkey.rb

Facter.add("pgsshpubkey") do
  setcode do
    Facter::Util::Resolution.exec('/bin/cat /var/lib/postgresql/.ssh/id_rsa.pub; echo " "')
  end
end

