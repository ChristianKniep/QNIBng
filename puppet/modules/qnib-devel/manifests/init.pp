class qnib-devel {
    $pkgToInstall = [ "git", "automake", "autoconf", "make", "bison", "flex", "file", "libtool", "python-devel", "glib2-devel", "rubygems", "ruby-devel", "createrepo", "rpm-build", "yum-utils", "bc", "cmake", "gcc-c++"]
    package { $pkgToInstall:
        ensure => "installed"
    }
    package { 'fpm':
        #require  => Package["ruby-devel"],
        require  => Package[$pkgToInstall],
        ensure   => 'installed',
        provider => 'gem',
    }
}