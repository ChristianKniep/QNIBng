class qnib-opensm {
    
    $pkgToInstall = [ "qnib-opensm" ]
    package { $pkgToInstall:
        ensure => "latest",
        require => File['/etc/yum.repos.d/qnib.repo'],
    }
    
    file { "/usr/etc/opensm":
        ensure => directory,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 755,
    }
    
    file { "/usr/etc/opensm/opensm.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/qnib-opensm/usr/etc/opensm/opensm.conf",
        require => File['/usr/etc/opensm'],
    }
}