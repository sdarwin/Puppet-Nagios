# manifests/target.pp

class nagios::target {

	include nrpe

    @@nagios_host { "${fqdn}":
        address => $ipaddress,
        alias => $hostname,
        use => 'generic-host',
	#hostgroups => 'redhat-servers' ;
	hostgroups => $::osfamily ? {
		"redhat" =>  'redhat-servers',
		"debian" =>  'debian-servers'
		};
	}
	
nagios::service::ping{testping:}

    if ($nagios_parents != '') {
        Nagios_host["${fqdn}"] { parents => $nagios_parents }
    }

}
