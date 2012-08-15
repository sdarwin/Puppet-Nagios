
class apache::debian {

 package { "apache2":
        ensure => present,
    }

service { apache:
    name => apache2,
    ensure => true,
    enable => true,
  }

}

