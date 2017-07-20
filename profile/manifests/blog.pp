class prefile::blog {

  #web server / php
  class {'apache:
    docroot  => '/var/www',
    port     => '8080',
  }
  
  class {'apche::mod::php':}
  
  #db server
  class {'mysql::server':
    root_password  => 'somepassword',
  }
  
  class {'mysql::bindings':
    php_enable  => true,
    #java_enable => true,
  }

  #blogging platform (wordpress)
  class {'wordpress':
    install_dir  => '/var/www/wp',
  }

}
