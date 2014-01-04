class qnib {
    include graphite-web
    include carbon
    include ibsim
    include statsd
    
    package { ["screen"]:
        ensure => "installed",
    }
    
    user { 'qnib':
        ensure => present,
        managehome => true,
    }
    
    file { "/home/qnib/.bashrc":
        owner   => qnib,
        group   => qnib,
        mode    => 600,
        source  => "puppet:///modules/qnib/home/qnib/bashrc",
        require => User['qnib'],
    }
    
    file { "/home/qnib/cluster_topo/":
        ensure => directory,
        recurse => true,
        owner   => qnib,
        group   => qnib,
        mode    => 755,
        require => User['qnib'],
    }
    
    file { "/home/qnib/cluster_topo/4nodes.nlst":
        owner   => qnib,
        group   => qnib,
        mode    => 644,
        source  => "puppet:///modules/qnib/home/qnib/cluster_topo/4nodes.nlst",
        require => User['qnib'],
    }
}