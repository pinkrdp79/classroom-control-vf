class profile::bloggingplatform {
  include apache
  include '::mysql::server'
  include wordpress
  
  apache::vhost { 'robisonba.puppetlabs.vm':
    port    => '80',
    docroot => '/var/www',
  }
  
  class { 'wordpress': }
}
