class profile::blog {  
    
    #webserver w/ php
    class { 'apache':
      docroot => '/var/www',
      port => '8080,
    }
    class { 'apache::mod::php': }
    
    #database
    class { 'mysql::server':
      root_password => 'changeit',
    }
    class { 'mysql::bindings':
      php_enable => true,
    }
    
    #blogging platform
    class { 'wordpress': 
      install_dir => '/var/www/wp'
    }
    
}
