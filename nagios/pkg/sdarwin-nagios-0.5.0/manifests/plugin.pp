define nagios::plugin(
    $source = 'absent',
    $ensure = present
){

   case $::osfamily {
    'redhat': {

   	case $::hardwaremodel {
    		'x86_64': {
        	$libpath = "lib64"
        	}
    		'i686': {
        	$libpath = "lib"
        	}
        	}

	}
    'debian': {
	$libpath = "lib"
	}
	}

  file{$name:
    path => "/usr/$libpath/nagios/plugins/$name",
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
