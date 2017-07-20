class profile::blog {
#web server /php
  class{'apache':
    docroot => '/var/www',
  }  

class {'apache::mod::php':}

#DB Server
class {'mysql::server'}
  root_password => 'supersecret'
  }

class {'mysql::bindings::php'}

class {'mysql::bindings':
  php_enable => true,
  }

#blogging platform (wordpress)
  class {'wordpress':
    install_dir => '/var/www/wp',
  }
}
