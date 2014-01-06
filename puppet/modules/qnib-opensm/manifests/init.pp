class qnib-opensm {
    
    exec { "yum_clean_all":
        command => "/bin/yum clean all",
    }
    
    $pkgToInstall = [ "qnib-opensm" ]
    package { $pkgToInstall:
        ensure => "installed",
        before => Exec['yum_clean_all'],
    }
    
    file { "/usr/etc/opensm":
        ensure => directory,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 755,
    }
    
    file { "/usr/etc/opensm/opensm.conf":
        notify  => Service['httpd'],
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/qnib-opensm/usr/etc/opensm/opensm.conf",
        require => File['/usr/etc/opensm'],
    }
}