class logstash {
    file { "/etc/yum.repos.d/logstash.repo":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/logstash/etc/yum.repos.d/logstash.repo",
    }
    exec { "clean_yum_for_logstash":
        command => "/bin/yum clean all",
        require  => File['/etc/yum.repos.d/logstash.repo'],
    }
    
    package { "logstash":
        ensure => "installed",
        require  => Exec['clean_yum_for_logstash'],
    }
    
    file { "/etc/logstash/conf.d/udp.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/logstash/etc/logstash/conf.d/udp.conf",
        require => Package['logstash'],
    }
    
    file { "/etc/sysconfig/logstash":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/logstash/etc/sysconfig/logstash",
        require => Package['logstash'],
    }
    
    service { "logstash":
        ensure => "running",
        enable => true,
        require => File['/etc/logstash/conf.d/udp.conf'],
    }
    
}