Puppet Modules for an HA environment 
====================================
Services provisioned:

 
	*Postgres - Streaming replication 
	*Rabbitmq-server - Disk nodes and mirrioring 
	*Redis-server -  Streaming replication
	*KeepAlived  - Provides VIP's and failover


Issues
------

This setup is running quite nicely in my lab right now (KVM machines) However Puppet needs to be run ~ twice on each node, so that the pubkeys can be shared between postgres accounts (passwordless ssh for replication rsync's)
Im still learning about puppet so I have still have improvments to add to these modules. For example, if you only have on rabbit node, you need to set multiple nodes to false, and then I run some ugly logic to create the config file thereafter. 
(I know that there is a better way!)


Installation
------------
see provided scope.example and node.example 
I have also included Per-module Documentation

Starting Replication
--------------------
Once the dust has settled and running puppet no longer changes anything, you need to restart postgres on the desired master node by hand. (I don't like puppet restarting databases on config refreshes) This will prompt the master to generate the correct type of log file for streaming replication.
Second as the postgres user on the defaul_slave you run /var/lib/postgresql/9.2/slave_spawn_from_master.bash $IP_OF_MASTER Which will do what one would expect and spawn a slave from the master. 

RabbitMQ
-------- 
Rabbit fails to start via the init.d after it's installed from the offical repo, to remedy this. kill all of rabbits PID's (init.d/rabbitmq stop does not work) Then start rabbit once by hand (exec rabbit-server) after it is started by hand the init file begins working as expected. I don't know why this is. It's on my TODO

This should kill your rabbit processes -> 

        for x in "$(ps -ef | grep -v grep | grep rabbit | awk '{print $2}')"; do kill -9 "$x"; echo "PID "$x" killed"; done

License
------
BSD

