class statsd {
    exec { "yum clean all":
        command => "/bin/yum clean all"
    }
    
    package { "qnib-statsd":
        ensure => "installed",
        require  => Exec['yum clean all'],
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