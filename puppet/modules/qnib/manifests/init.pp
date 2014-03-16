class qnib {

    
    include graphite-web
    include ibsim
    include logstash
    include statsd
    include qnib-opensm    
    include carbon
    
    file { "/etc/yum.repos.d/qnib.repo":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/qnib/etc/yum.repos.d/qnib.repo",
    }
    
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
    
    file { "/root/cluster_topo/64nodes.nlst":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/qnib/cluster_topo/64nodes.nlst",
        require => File['/root/cluster_topo'],
    }
    
    file { "/root/cluster_topo/256nodes.nlst":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/qnib/cluster_topo/256nodes.nlst",
        require => File['/root/cluster_topo'],
    }
    
    
}
