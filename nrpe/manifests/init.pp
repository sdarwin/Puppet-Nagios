
class nrpe {

 	Host <<||>>

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

