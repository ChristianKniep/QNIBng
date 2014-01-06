class carbon {

    package { "python-carbon":
        ensure => "installed"
    }
    
    service { "carbon-cache":
        ensure => "running",
        enable => true,
    }
    
    exec { "carbon-cache_reload":
        command => "/bin/systemctl --system daemon-reload",
        notify =>  Service['carbon-cache'], 
    }
    
    exec { "carbon-cache_stop":
        command => "/bin/systemctl stop carbon-cache.service",
    }
    
    file { "/etc/init.d/carbon-cache":
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/carbon/etc/init.d/carbon-cache",
        require => Package['python-carbon'],
        before  => Exec['carbon-cache_stop'],
        notify  => Exec['carbon-cache_reload'],
    }
    
    file { "/etc/carbon/c0.conf":
        notify  => Service['carbon-cache'], 
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/carbon/etc/carbon/c0.conf",
        require => Package['python-carbon'],
    }
    
    file { "/etc/carbon/storage-schemas.conf":
        notify  => Service['carbon-cache'], 
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/carbon/etc/carbon/storage-schemas.conf",
        require => Package['python-carbon'],
    }
    
}