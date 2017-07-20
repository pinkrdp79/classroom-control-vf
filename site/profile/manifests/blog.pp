class profile::blog {  
    
    #webserver w/ php
    apache::vhost { 'robisonba.puppetlabs.vm':
      port    => '80',
      docroot => '/var/www/wp',
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
