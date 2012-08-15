class nagios::defaults::services {

nagios_service {
	'check_root':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'root filesystem',
        check_command => 'check_nrpe!check_root';
	}

nagios_service {
        'check_boot':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'boot filesystem',
        check_command => 'check_nrpe!check_boot';
        }

nagios_service {
        'check_home':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'home filesystem',
        check_command => 'check_nrpe!check_home';
        }

nagios_service {
        'check_opt':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'opt filesystem',
        check_command => 'check_nrpe!check_opt';
        }

nagios_service {
        'check_var':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'var filesystem',
        check_command => 'check_nrpe!check_var';
        }

nagios_service {
        'check_usr':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'usr filesystem',
        check_command => 'check_nrpe!check_usr';
        }
nagios_service {
        'check_load':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'check load',
        check_command => 'check_nrpe!check_load';
        }

nagios_service {
        'check_swap':
        use => 'generic-service',
        hostgroup_name => 'linux-servers',
        service_description => 'check swap',
        check_command => 'check_nrpe!check_swap';
        }


}
