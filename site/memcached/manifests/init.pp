class memcached {
  package { 'memcached':
    ensure => present,
  }
  
  file { 'memcached.conf':
    ensure => file,
    path   => '/etc/sysconfig/memcached',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet://modules/memcache/mecached.conf',
  {

  service { 'memcached':
    ensure    => 'running',
    enable    => 'true',
    subscribe => [ File['memcached.conf']],
  }
}
