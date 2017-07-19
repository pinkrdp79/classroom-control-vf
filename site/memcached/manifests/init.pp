class memcached {
  package { 'memcached':
    ensure => present,
  }

  file { 'memcached':
    path => '/etc/sysconfig/memcached',
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/memcached/memcached',
    require => Package['memcached'],
  }

  service { 'memcache':
    ensure => running,
    enable => true,
    subscribe => File['memcached'],
  }
}
