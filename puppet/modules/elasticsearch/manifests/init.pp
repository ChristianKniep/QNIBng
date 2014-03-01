class elasticsearch {
    file { "/etc/yum.repos.d/elasticsearch.repo":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/elasticsearch/etc/yum.repos.d/elasticsearch.repo",
    }
    exec { "clean_yum_for_es":
        command => "/bin/yum clean all",
        require  => File['/etc/yum.repos.d/elasticsearch.repo'],
    }
    
    package { "elasticsearch":
        ensure => "installed",
        require  => Exec['clean_yum_for_es'],
    }
    
    # Should be a template to include hostname
    $str = "cluster.name: qnibES
node.name: $hostname
"
    file { "/etc/elasticsearch/elasticsearch.yml":
        owner   => root,
        group   => root,
        mode    => 644,
        #source  => "puppet:///modules/elasticsearch/etc/elasticsearch/elasticsearch.yml",
        content => "$str"
        require => Package['elasticsearch'],
    }
    
    service { "elasticsearch":
        ensure => "running",
        enable => true,
        require => File['/etc/elasticsearch/elasticsearch.yml'],
    }
    
}