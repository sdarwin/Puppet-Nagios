class nagios::redhat inherits nagios::base {

    package { 'nagios':
        alias => 'nagios',
        ensure => present,
    }

    service { 'nagios':
        ensure => running,
        enable => true,
        #hasstatus => true, #fixme!
        require => Package['nagios'],
    }


#moving 'nagios-plugins-nrpe' to nrpe module
    package { [ 'nagios-plugins-smtp','nagios-plugins-http', 'nagios-plugins-ssh', 'nagios-plugins-tcp', 'nagios-plugins-dig', 'nagios-plugins-load', 'nagios-plugins-dns', 'nagios-plugins-ping', 'nagios-plugins-procs', 'nagios-plugins-users', 'nagios-plugins-ldap', 'nagios-plugins-disk', 'nagios-plugins-swap', 'nagios-plugins-nagios', 'nagios-plugins-ntp', 'nagios-plugins-snmp' ]:
        ensure => 'present',
        notify => Service['nagios'],
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

    Service[nagios]{
        hasstatus => true,
    }

    if ($nagios_allow_external_cmd) {
        file { '/var/spool/nagios/cmd':
            ensure => 'directory',
            require => Package['nagios'],
            mode => 2660, owner => apache, group => nagios,
        }
    }
}
