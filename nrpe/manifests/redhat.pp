class nrpe::redhat {
    if ($architecture == "i386") {
        $libpath = "lib"
    } else {
        $libpath = "lib64"
    }

	#what is perl-Nagios-Plugin    
    package { [ "nagios-nrpe", "perl-DBI" ]:
        ensure  => present,
        require => Yumrepo["epel"];
    }

	if !defined(Package["nagios-plugins"]) {
        package {"nagios-plugins":
                ensure => installed,
                notify => Service['nagios'],
                }
        }

	if !defined(Package["nagios-plugins-perl"]) {
        package {"nagios-plugins-perl":
                ensure => installed,
                notify => Service['nagios'],
                }
        }

	if !defined(Package["nagios-plugins-nrpe"]) {
        package {"nagios-plugins-nrpe":
                ensure => installed,
                notify => Service['nagios'],
                }
        }


    service { "nrpe":
        ensure    => running,
        enable    => true,
        require => [ Package["nagios-nrpe"], Package["nagios-plugins-nrpe"] ],
        subscribe => File["/etc/nagios/nrpe.cfg"];
    }

   $pid_file = "/var/run/nrpe.pid"

    file { 
        "/etc/nagios/nrpe.cfg":
            ensure  => present,
            owner   => "nagios",
            group   => "nagios",
            mode    => "0664",
            content => template("nrpe/nrpe.cfg.erb"),
            require => Package["nagios-nrpe"];

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
