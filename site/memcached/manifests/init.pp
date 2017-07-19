class memcached {
  package { 'memcached':
    ensure => present,
    }
  file { 'memcached':
    path => '/etc/sysconfig',
    ensure => file,
    owner => root,
    group => root,
    mode => '0644',
    source => 'puppet:///modules/memcached/memcached',
    require => Package['memcached'],
    }
  service { 'memcached':
    ensure => running,
    enabled => true,
    subscribe => File['memcached'],
    }
}
