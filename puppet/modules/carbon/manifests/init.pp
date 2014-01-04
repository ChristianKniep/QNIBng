class carbon {
    package { "python-carbon":
        ensure => "installed"
    }
    
    file { "/etc/init.d/carbon-cache":
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/carbon/etc/init.d/carbon-cache",
        require => Package['python-carbon'],
    }
    
    file { "/etc/carbon/c0.conf":
        notify  => Service['carbon-cache'], 
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/carbon/etc/carbon/c0.conf",
        require => Package['python-carbon'],
    }
    service { "carbon-cache":
        ensure => "running",
        enable => true,
    }
}