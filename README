Puppet Modules for an HA environment 
====================================
I have been working on. Services include Postgres 9.2, rabbitmq-server 2.8.7, redis-server 2.4.16. Keepalived provieds VIP's for HA. It's all coupled together and needs to be refinced, but it does infact work. I'll be updating this as I find problems in testing. 


This collection of modules was meant for a very specific and I'll admit rushed project, and is thus rather inflexible, there are a handful of hardcoded problems that I'll work on in the next iteration. (as I learn puppet better)
For example, if you only have on rabbit node, you need to set multiple nodes to false, and I run some ugly logic to create the config file thereafter. 

Installation
------------
see: top scope and node examples

TODO: Puppet must be run on both nodes more than once, as It generates and then exports @postgres's public keys pupulating authorized_keys between machines using a custom fact. I need this to run passwordless rsync and ssh between the machines when creating the master -> slave setup.

Once the dust has settled and the services are running as the postgres user on the defaul_slave you can run /var/lib/postgresql/9.2/slave_spawn_from_master.bash $IP_OF_MASTER Which will do what one would expect and spawn a slave from the master. 

I have also included rough Per-module Documentation

License
------
GPL or something, I guess, I will certainly not come after anyone.

Support
-------
None provided, really this is for my own reference, and If you want to look at it you might get some ideas (possible bad ones) But hey, you never know. 
