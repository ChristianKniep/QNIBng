===================
QNIBng on Vagrant
===================

---------------------------------
Run the QNIBng stack within a VM
---------------------------------

Overview
===============================

To try out the QNIBng stack by using the InfiniBand simulator *ibsim*
the 'batterie-included' vagrant box can be used.

Vagrant
--------

`Vagrant <http://wwww.vagrantup.com>`_ is a wrapper around VirtualBox (VMware, even OpenStack) that helps automate
the process and keep it reproducable.



.. code:: bash

    QNIBng (master)$ vagrant box add fd19 http://smith.rmz.uni-lueneburg.de/vagrantboxes/fd19.2014-01-15.box
    Downloading box from URL: http://smith.rmz.uni-lueneburg.de/vagrantboxes/fd19.2014-01-15.box
    Extracting box...
    Successfully added box 'fd19' with provider 'virtualbox'!
    QNIBng (master)$ vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    [default] Importing base box 'fd19'...
    [default] Matching MAC address for NAT networking...
    [default] Setting the name of the VM...
    [default] Clearing any previously set forwarded ports...
    [default] Clearing any previously set network interfaces...
    [default] Preparing network interfaces based on configuration...
    [default] Forwarding ports...
    [default] -- 22 => 2222 (adapter 1)
    [default] -- 80 => 8088 (adapter 1)
    [default] Running 'pre-boot' VM customizations...
    [default] Booting VM...
    [default] Waiting for machine to boot. This may take a few minutes...
    [default] Machine booted and ready!
    [default] Mounting shared folders...
    [default] -- /repo
    [default] -- /vagrant
    [default] -- /tmp/vagrant-puppet-1/manifests
    [default] -- /tmp/vagrant-puppet-1/modules-0
    [default] Running provisioner: puppet...
    Running Puppet with init.pp...
    Warning: Could not retrieve fact ipaddress
    Notice: Compiled catalog for vagrant-fedora-19.vagrantup.com in environment production in 2.74 seconds
    *snip*
    Notice: Finished catalog run in 483.99 seconds
    QNIBng (master)$ 