class nagios::defaults::hostgroups {
  nagios_hostgroup {
    'linux-servers':
      alias => 'Linux Servers',
      hostgroup_members => ['redhat-servers','debian-servers']
	}
 nagios_hostgroup {
    'all':
      alias   => 'All Servers',
    	members => '*';
    'debian-servers':
      alias   => 'Debian GNU/Linux Servers';
    'redhat-servers':
      alias   => 'RedHat GNU/Linux Servers';
	}
	}

