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

	include nagios::common

    Service[nagios]{
        hasstatus => true,
    }

       user { apache:
                ensure => present
                }

    if ($nagios_allow_external_cmd) {
        file { '/var/spool/nagios/cmd':
            ensure => 'directory',
            require => Package['nagios'],
            mode => 2660, owner => apache, group => nagios,
        }
    }
}
