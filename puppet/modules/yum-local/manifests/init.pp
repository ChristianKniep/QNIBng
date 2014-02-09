class yum-local {
    file { "/etc/yum.repos.d/fedora.repo":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/yum/etc/yum.repos.d/fedora.repo.local",
    }
    file { "/etc/yum.repos.d/fedora-updates.repo":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/yum/etc/yum.repos.d/fedora-updates.repo.local",
    }
}
