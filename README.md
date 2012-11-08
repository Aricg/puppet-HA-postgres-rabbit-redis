Puppet Modules for an HA environment 
====================================
Services provisioned:

 
	*Postgres - Streaming replication 
	*Rabbitmq-server - Disk nodes and mirrioring 
	*Redis-server -  Streaming replication
	*KeepAlived  - Provides VIP's and failover


Issues
------

This setup is running quite nicely in my lab right now (KVM machines) However Puppet needs to be run ~ twice on each node, once to generate ssh keys for the postgres user and again to share id_rsa.pub into the other machines known_hosts req of (start replication rsync script)
Im still improving these modules -- For example, if you only have one rabbit node, you need to set multiple nodes to false, and then I run some ugly logic to create the config file thereafter. 
(I know that there is a better way!)


Installation
------------
see provided scope.example and node.example 
I have also included Per-module Documentation

Starting Replication
--------------------
	*Restart postgres on the desired master. (I don't like puppet calling restarting postgres on config changes) This will prompt the master to generate the correct type of log file for streaming replication.
	*su to the postgres user on the defaul_slave machine and run /var/lib/postgresql/9.2/slave_spawn_from_master.bash $IP_OF_MASTER 

RabbitMQ
-------- 
Rabbit fails to start via the init.d after it's installed from the offical repo, to remedy this kill all of rabbits PID's (init.d/rabbitmq stop does not work) Then start rabbit once by hand (exec rabbit-server) after it is started by hand the init file begins working as expected. I don't know why this is. It's on my TODO

This should kill your rabbit processes -> 

        for x in $(ps -ef | grep -v grep | grep rabbit | awk '{print $2}'); do kill -9 "$x"; echo "PID "$x" killed"; done

Iptables
--------
Iptables is only meant to be used if you have two interfaces (one internal and one public) It applies the default Redhat firewall against eth0. You have been warned.

Security
--------
In my environment all of these machines are isolated by iptables blocking any connections through the public interface.
If you do not have the luxury of a trusted private network please do not run this in any serious manner without fisrt adressing how you are going to secure these services.

License
------
BSD

