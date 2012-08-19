class nagios::apache inherits ::apache {
    $nagios_httpd = 'apache'

    case $::osfamily {
        'debian': {
            file { "${nagios::defaults::vars::int_nagios_cfgdir}/apache2.conf":
                ensure => present,
                source => ["puppet:///nagios/configs/apache2.conf"],
            }

            file { "/etc/apache2/conf.d/nagios3.conf":
                ensure => link,
                target => "${nagios::defaults::vars::int_nagios_cfgdir}/apache2.conf",
                require => File["${nagios::defaults::vars::int_nagios_cfgdir}/apache2.conf"],
            }
        }
    }
}
