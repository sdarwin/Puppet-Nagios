class nrpe::redhat {
    if ($architecture == "i386") {
        $libpath = "lib"
    } else {
        $libpath = "lib64"
    }

	#what is perl-Nagios-Plugin    
    package { [ "nrpe", "perl-DBI" ]:
        ensure  => present,
        require => Yumrepo["epel"];
    }

    service { "nrpe":
        ensure    => running,
        enable    => true,
        require => [ Package["nrpe"], Package["nagios-plugins-nrpe"] ],
        subscribe => File["/etc/nagios/nrpe.cfg"];
    }

   $pid_file = "/var/run/nrpe/nrpe.pid"

    file { 
        "/etc/nagios/nrpe.cfg":
            ensure  => present,
            owner   => "nagios",
            group   => "nagios",
            mode    => "0664",
            content => template("nrpe/nrpe.cfg.erb"),
            require => Package["nrpe"];

        "/usr/$libpath/nagios/plugins":
            ensure   => directory,
            owner    => "root",
            group    => "root",
            mode     => "0755",
            source   => "puppet:///modules/nrpe/redhat/plugins",
            recurse  => true,
            require  => Package["nagios-plugins-nrpe"];
    }
}
