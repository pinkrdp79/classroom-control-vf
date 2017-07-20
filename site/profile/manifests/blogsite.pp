class profile::blogsite {

  class { 'apache':
    docroot => '/var/www'
  }
  class { 'apache::mod::php': }
  class {'mysql::server': root_password => 'password', }
  class { 'mysql::bindings': php_enabled => true, }
  class { 'wordpress': install_dir => '/var/www/wp', }
}
