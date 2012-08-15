
class apache {

 package { "httpd":
        ensure => present,
    }

file { "httpd.conf":
	path => "/etc/httpd/conf/httpd.conf",

	}

service { apache:
    name => httpd,
    ensure => true,
    enable => true,
    subscribe => [ File["/etc/httpd/conf/httpd.conf"],
                   Package["httpd"] ]
  }

apache::vhost {'nagios':
      port => 80,
      docroot => '/var/www/html/nagios',
      priority => 25,
      servername => 'nagios',
    }

}

