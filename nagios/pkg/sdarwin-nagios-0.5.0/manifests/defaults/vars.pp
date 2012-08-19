class nagios::defaults::vars {
  case $::nagios_cfgdir {
    '': { $int_nagios_cfgdir = $::osfamily ? {
            redhat => '/etc/nagios/',
            default => '/etc/nagios3'
          }
    }
    default: { $int_nagios_cfgdir = $::nagios_cfgdir }
  }
}
