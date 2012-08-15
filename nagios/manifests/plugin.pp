define nagios::plugin(
    $source = 'absent',
    $ensure = present
){


   case $::osfamily {
    'redhat': {
        $libpath = "lib64"
	}
    'debian': {
	$libpath = "lib"
	}
	}

  file{$name:
    path => $hardwaremodel ? {
      'x86_64' => "/usr/$libpath/nagios/plugins/$name",
      default => "/usr/$libpath/nagios/plugins/$name",
    },
    ensure => $ensure,
    source => $source ? {
      'absent' => "puppet:///modules/nagios/plugins/$name",
      default => "puppet:///modules/$source"
    },
    tag => 'nagios_plugin',
    require => Package['nagios-plugins'],
    owner => root, group => 0, mode => 0755;
  }
}
