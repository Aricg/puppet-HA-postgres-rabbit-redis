#these prep the system for non local bind, needed by keepalived
class keepalived::scripts( 
){
            exec { "enable non local bind":
                command => 'echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind;
echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf;
sysctl -p;',
                user => 'root',
                unless => "cat /etc/sysctl.conf | grep net.ipv4.ip_nonlocal_bind",
            }



}

