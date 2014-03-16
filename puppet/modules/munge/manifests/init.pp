class munge {
    
    package { "munge":
        ensure => "latest",
    }
    
    file { "/var/lib/munge":
        ensure => directory,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 755,
        require => Package["munge"],
    }
    
    file { "/run/munge":
        ensure => directory,
        owner   => root,
        group   => root,
        mode    => 755,
        require => Package["munge"],
    }
   
    file { "/etc/munge":
        ensure => directory,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 755,
        require => Package["munge"],
    }
    
    file { "/var/log/munge":
        ensure => directory,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 755,
        require => Package["munge"],
    }
    
    file { "/etc/munge/munge.key":
        owner   => root,
        group   => root,
        mode    => 400,
        source  => "puppet:///modules/munge/etc/munge/munge.key",
        require => File['/etc/munge'],
    }
    
}