
class apache::redhat {

 package { "httpd":
        ensure => present,
    }

service { apache:
    name => httpd,
    ensure => true,
    enable => true,
  }

}

