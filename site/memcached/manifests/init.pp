class memcached {

  package { 'memcached':
    ensure => present,
  }

  file { 'memcached':
    ensure => file,
    path   => '/etc/sysconfig/memcached',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    source => 'puppet:///modules/memcached/memcached.txt',
  }
  
  service { 'memcached' :
    ensure => running,
  }
}
