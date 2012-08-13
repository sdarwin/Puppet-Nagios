class nagios::defaults::hostgroups {
  nagios_hostgroup {
    'linuxservers':
      alias => 'Linux Servers';
      hostgroup_members => 'redhat-servers','debian-servers';
    'all':
      alias   => 'All Servers',
    	members => '*';
    'debian-servers':
      alias   => 'Debian GNU/Linux Servers';
    'redhat-servers':
      alias   => 'RedHat GNU/Linux Servers';
	}
	}

