class memcached {
  package {
    ensure => present,
  }
  
  file { 'memcached.conf':
    ensure => file,
    path   => '/etc/sysconfig/memcached',
    source => 'puppet://modules/memcache/mecached.conf',
  {

  service { 'memcached':
    ensure    => running,
    enable    => true,
    subscribe => [ File['memcached.conf']],
  }
}
