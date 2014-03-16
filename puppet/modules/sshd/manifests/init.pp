class sshd {
    
    package { "openssh-server":
        ensure => "latest",
    }

    exec { "sshd_keygen":
        command => "/usr/sbin/sshd-keygen",
        require => Package["openssh-server"],
    }
    file { "/etc/ssh/auhorized_keys":
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/sshd/etc/ssh/auhorized_keys",
        require => Augeas['sshd_config'],
    }

    augeas { "sshd_config":
        context => "/files/etc/ssh/sshd_config/",
        changes => [
          "set AuthorizedKeysFile /etc/ssh/authorized_keys",
          "set IgnoreUserKnownHosts yes",
        ],
        require => Package["openssh-server"],
    }
    
}