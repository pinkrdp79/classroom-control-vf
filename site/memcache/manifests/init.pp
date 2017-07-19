class memcache {
  package {
    ensure => present,
  }
  
  file { 'memcached.conf':
    ensure => file,
    path => '/etc/sysconfig/memcached',
  {

  service { 'memcached':
    ensure    => running,
    enable    => true,
    subscribe => [ File['memcached.conf']]
  }
}
