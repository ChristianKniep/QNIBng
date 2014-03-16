class ibsim {
    file { "/etc/yum.repos.d/qnib.repo":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/ibsim/etc/yum.repos.d/qnib.repo",
    }
    
    package { [ "qnib-ibsim", "qnib-infiniband-diags" ]:
        ensure => "installed",
        require => File['/etc/yum.repos.d/qnib.repo'],
    }
}