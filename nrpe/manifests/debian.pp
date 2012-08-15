class nrpe::debian {

# if ($architecture == "i386") {
#        $libpath = "lib"
#    } else {
#        $libpath = "lib64"
#    }

    $libpath = "lib"

    package { [ "nagios-nrpe-server", "libnagios-plugin-perl", "libcache-cache-perl" ]: ensure => present }

if !defined(Package["nagios-plugins"]) {
        package {"nagios-plugins":
                ensure => installed,
                }
        }


    service { "nagios-nrpe-server":
        ensure  => running,
        enable  => true,
        pattern => "nrpe",
        require => Package["nagios-nrpe-server"],
    }

    $pid_file = "/var/run/nagios/nrpe.pid"

    file {
        "/usr/lib/nagios/plugins/contrib":
            ensure  => directory,
            owner   => "root",
            group   => "root",
            mode    => "0755",
            recurse => true,
            purge   => true,
            source  => "puppet:///modules/nrpe/debian/contrib",
            require => Package["nagios-nrpe-server"],
            notify  => Service["nagios-nrpe-server"];

        "/etc/nagios/nrpe.cfg":
            ensure  => present,
            owner   => "nagios",
            group   => "nagios",
            mode    => "0664",
	    #S.D. new
	    content => template("nrpe/nrpe.cfg.erb"),	
            #source  => "puppet:///modules/nrpe/nrpe.cfg",
            require => Package["nagios-nrpe-server"],
            notify  => Service["nagios-nrpe-server"];
    }

    tidy { "/etc/default":
        recurse => true,
        matches => "nagios-nrpe-server",
    }
}
