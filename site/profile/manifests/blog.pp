class profile::blogsite {

  class { 'apache':
    docroot => '/var/www'
    }
    class { 'apache::mod::php': }
    
    
