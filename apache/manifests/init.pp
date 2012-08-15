class apache {

    case $::osfamily {
        'redhat': {
            include apache::redhat
        }
        'debian': {
            include apache::debian
        }
        default: { fail("No such osfamily: ${::osfamily} yet defined") }
    }
}

