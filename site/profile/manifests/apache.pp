class profile::apache {
  class { 'apache':
    docroot => '/var/www',
  }
  class { 'apache::mod::php': }
}
