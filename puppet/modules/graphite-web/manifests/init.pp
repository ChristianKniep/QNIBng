class graphite-web {
    
    $packagesToBeInstalled = [ "graphite-web", "nmap-ncat" ]
    package { $packagesToBeInstalled:
        ensure => "installed",
    }
    
    package {"httpd":
        ensure => "installed",
    }
    
    service { "httpd":
        ensure => "running",
        enable => true,
        require => Package['httpd'],
    }
    service { "firewalld":
        ensure => "stopped",
        enable => false,
    }
    file { "/etc/httpd/conf.d/graphite-web.conf":
        notify  => Service['httpd'],
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/graphite-web/etc/httpd/conf.d/graphite-web.conf",
        require => Package['httpd'],
    }
    
    file { "/etc/selinux.config":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/graphite-web/etc/selinux/config",
    }
    file { "/var/lib/graphite-web/":
        ensure => directory,
        recurse => true,
        owner   => apache,
        group   => apache,
        mode    => 644,
        require => Service['httpd'],
    }
    
    file { "/etc/graphite-web/local_settings.py":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/graphite-web/etc/graphite-web/local_settings.py",
        require => Package[$packagesToBeInstalled], 
        notify  => Service['httpd'],
    }
    
    file { "/var/tmp/initial_data.json":
        owner   => root,
        group   => root,
        mode    => 600,
        source  => "puppet:///modules/graphite-web/var/tmp/initial_data.json",
    }
    exec { "init_graphiteweb":
        cwd     => "/var/tmp/",
        command => "/usr/lib/python2.7/site-packages/graphite/manage.py syncdb --noinput",
        require =>  File['/var/tmp/initial_data.json'],
        notify  => Service['httpd'],
    }
    
    exec { "disable_selinux":
        command => "/sbin/setenforce 0",
        notify  => Service['httpd'],
        unless => "/usr/bin/grep -c SELINUX=disabled /etc/selinux/config",
    }
    
}
