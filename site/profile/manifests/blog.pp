class profile::blog{
  class {'apache':
  }
  class  {'apache::mod:php'
    docroot => '/var/www'
  }
  include 'mysql::server'
  include wordpress
}
