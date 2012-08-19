
class nagios::common {

	#for plugins which are shared with external nrpe puppet module
	#so, nrpe will be calling this class

	#move more plugin code over to this file?

case $::osfamily {

'redhat': {

    package { [ 'nagios-plugins', 'nagios-plugins-perl', 'nagios-plugins-nrpe', 'nagios-plugins-smtp','nagios-plugins-http', 'nagios-plugins-ssh', 'nagios-plugins-tcp', 'nagios-plugins-dig', 'nagios-plugins-load', 'nagios-plugins-dns', 'nagios-plugins-ping', 'nagios-plugins-procs', 'nagios-plugins-users', 'nagios-plugins-ldap', 'nagios-plugins-disk', 'nagios-plugins-swap', 'nagios-plugins-nagios', 'nagios-plugins-ntp', 'nagios-plugins-snmp' ]:
        ensure => 'present',
        #notify => Service['nagios'],
    }

	}
'debian': {

        exec { "apt-update":
                command => "/usr/bin/touch /tmp/apt-get-update ; /usr/bin/apt-get update",
                onlyif => "/bin/sh -c '[ ! -f /tmp/apt-get-update ] || test `find /tmp/apt-get-update -mmin +1440` > /dev/null 2>@1'",
                }

    package { [ 'nagios-snmp-plugins' ]:
        ensure => 'present',
        #notify => Service['nagios'],
    require => Exec["apt-update"],
}

if !defined(Package["nagios-plugins"]) {
        package {"nagios-plugins":
                ensure => installed,
                #notify => Service['nagios'],
                require => Exec["apt-update"],
                }
        }
}
default: { fail("No such osfamily: ${::osfamily} yet defined") }

}
}



