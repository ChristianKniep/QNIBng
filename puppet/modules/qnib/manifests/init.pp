class qnib_carbon inherits carbon {
    File["/etc/carbon/storage-schemas.conf"] {
        source  => "puppet:///modules/qnib/etc/carbon/storage-schemas.conf",
    }
}

class qnib {

    package { ["qnib-fd-repo", "qnib-repo"]:
        ensure => "installed",
    }
    
    include graphite-web
    include ibsim
    include statsd
    include qnib-opensm    
    include qnib_carbon
    
    package { ["screen"]:
        ensure => "installed",
    }
    
    file { "/usr/local/sbin/ibsim_activate":
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/qnib/usr/local/sbin/ibsim_activate",
    }
    
    file { "/root/cluster_topo/":
        ensure => directory,
        recurse => true,
        owner   => root,
        group   => root,
        mode    => 755,
    }
    
    file { "/root/cluster_topo/4nodes.nlst":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/qnib/cluster_topo/4nodes.nlst",
        require => File['/root/cluster_topo'],
    }
    
    
}
