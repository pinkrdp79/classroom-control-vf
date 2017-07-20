class profile::blog {
  class { 'apache': 
  docroot => '/var/www',
  port => '8080',
  }
  class { 'apache::mod::php': }
  class { 'mysql::server': root_password => 'supersecret', }
  class { 'mysql::bindings': php_enable => true, }
  class { 'wordpress': install_dir => '/var/www/wp', }
}
