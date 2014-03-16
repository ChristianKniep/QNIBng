class docker {

    package { [ "docker-io" ]:
        ensure => "latest",
    }
    
    service { "docker":
        ensure => "running",
        enable => true,
        require => Package["docker-io"],
    }
    
    #file { "/etc/yum.repos.d/qnib.repo":
    #    owner   => root,
    #    group   => root,
    #    mode    => 644,
    #    source  => "puppet:///modules/ibsim/etc/yum.repos.d/qnib.repo",
    #}
}