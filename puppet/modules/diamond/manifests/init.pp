class diamond {

    package { [ "python-diamond", "python-configobj" ]:
        ensure => "latest",
        require => File["/etc/yum.repos.d/qnib.repo"],
    }
    
    file { "/etc/yum.repos.d/qnib.repo":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/diamond/etc/yum.repos.d/qnib.repo",
    }
    
    if $::vagrant != 'true' {
        service { "diamond":
            ensure => "running",
            enable => true,
            require => File["/usr/lib/systemd/system/diamond.service"],
        }
    }
    
    file { "/var/log/diamond":
        ensure => directory,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 755,
    }
    
    file { "/etc/diamond/diamond.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/diamond/etc/diamond/diamond.conf",
        require => Package["python-diamond", "python-configobj"],
    }
    
    file { "/etc/diamond/handlers/GraphiteHandler.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/diamond/etc/diamond/handlers/GraphiteHandler.conf",
        require => Package["python-diamond", "python-configobj"],
    }
    
    file { "/etc/diamond/collectors/SNMPInterfaceCollector.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/diamond/etc/diamond/collectors/SNMPInterfaceCollector.conf",
        require => Package["python-diamond", "python-configobj"],
    }
    
    file { "/etc/diamond/collectors/NetworkCollector.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/diamond/etc/diamond/collectors/NetworkCollector.conf",
        require => Package["python-diamond", "python-configobj"],
    }
    
    file { "/etc/diamond/collectors/EntropyStatCollector.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/diamond/etc/diamond/collectors/EntropyStatCollector.conf",
        require => Package["python-diamond", "python-configobj"],
    }
    
    file { "/usr/lib/systemd/system/diamond.service":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/diamond/usr/lib/systemd/system/diamond.service",
        require => Package["python-diamond", "python-configobj"],
    }
}