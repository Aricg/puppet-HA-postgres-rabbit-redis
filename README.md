Puppet Modules for an HA environment 
====================================
Services included 
	Postgres - streaming replication 
	Rabbitmq-server - disk nodes and mirrioring 
	Redis-server with replication

HA Provided By - Keepalived VIP's and failover.

Its running quite nicely in my lab right now (kvm machines) but puppet still needs to be run 2x on each node, so that the pubkeys can be shared between postgres accounts (passwordless ssh for replication rsync's)

Im learning puppet everyday so I have amny improvments to add to these modules. For example, if you only have on rabbit node, you need to set multiple nodes to false, and then I run some ugly logic to create the config file thereafter. 
(there is a better way!)

Installation
------------
see: top scope and node examples

Manual steps:Once the dust has settled and running puppet no longer changes anything, you need to restart postgres by hand (I don't like puppet restarting databases on config refreshes) And then as the postgres user on the defaul_slave you can run /var/lib/postgresql/9.2/slave_spawn_from_master.bash $IP_OF_MASTER Which will do what one would expect and spawn a slave from the master. 

Rabbit: Sometimes rabbit seems to fail to start the fisrt run, kill all its PID's and start it by hand (rabbit-server) after that the init file will work as expected

I have also included rough Per-module Documentation

License
------
GPL or something, I guess? Go nuts. 

Support
-------
None provided, really this is for my own reference, and If you want to look at it you might get some ideas (possible bad ones) But hey, you never know. 

