class nagios::debian inherits nagios::base {

	Exec["apt-update"] -> Package <| |> 

	exec { "apt-update":
		command => "/usr/bin/touch /tmp/apt-get-update ; /usr/bin/apt-get update",
		onlyif => "/bin/sh -c '[ ! -f /tmp/apt-get-update ] || test `find /tmp/apt-get-update -mmin +1440` > /dev/null 2>@1'",
		}

	include nagios::apache

    package { 'nagios':
         name => 'nagios3',
         require => Exec["apt-update"],
         }
    service { 'nagios':
        name => 'nagios3',
        hasstatus => true,
        }
	include nagios::common


    File['nagios_htpasswd', 'nagios_cgi_cfg'] { group => 'www-data' }

    file { "${nagios::defaults::vars::int_nagios_cfgdir}/stylesheets":
        ensure => directory,
        purge => false,
        recurse => true,
    }

    if ($nagios_allow_external_cmd) {
        exec { 'nagios_external_cmd_perms_overrides':
            command => '/usr/sbin/dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw && /usr/sbin/dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3',
            unless => '/usr/sbin/dpkg-statoverride --list nagios www-data 2710 /var/lib/nagios3/rw && /usr/sbin/dpkg-statoverride --list nagios nagios 751 /var/lib/nagios3',
            logoutput => false,
            notify => Service['nagios'],
	    require => [User['nagios'],Group['nagios']]
        }
        exec { 'nagios_external_cmd_perms_1':
            command => '/bin/chmod 0751 /var/lib/nagios3 && /bin/chown nagios:nagios /var/lib/nagios3',
            unless => '/usr/bin/test "`stat -c "%a %U %G" /var/lib/nagios3`" = "751 nagios nagios"',
            notify => Service['nagios'],
		require => [User['nagios'],Group['nagios']]
        }
        exec { 'nagios_external_cmd_perms_2':
            command => '/bin/chmod 2751 /var/lib/nagios3/rw && /bin/chown nagios:www-data /var/lib/nagios3/rw',
            unless => '/usr/bin/test "`stat -c "%a %U %G" /var/lib/nagios3/rw`" = "2751 nagios www-data"',
            notify => Service['nagios'],
		require => [User['nagios'],Group['nagios']]
        }
    }
}
