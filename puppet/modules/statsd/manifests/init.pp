class statsd {
    
    package { "qnib-statsd":
        ensure => "latest",
    }
    
    service { "statsd":
        ensure => "running",
        enable => true,
        require => Package['qnib-statsd'],
    }
    
    file { "/etc/statsd/config.js":
        notify  => Service['statsd'],
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/statsd/etc/statsd/config.js",
        require => Package['qnib-statsd'],
    }
}