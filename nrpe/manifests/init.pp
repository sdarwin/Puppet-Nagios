
class nrpe {
	#automated this collection?
    #$nagiosip1 = '23.20.253.148'
    #$nagiosip2 = '10.29.160.230'

    $nagiosip1 = '10.212.79.90'
    $nagiosip2 = 'nagios-server'

    case $::osfamily {
        'redhat': {
		include nrpe::yum
            include nrpe::redhat
        }
        'debian': {
            include nrpe::debian
        }
        default: { fail("No such osfamily: ${::osfamily} yet defined") }
    }
}

