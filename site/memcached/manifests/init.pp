class memcached {
  package {'memcached':
    ensure => present,
  }
  
  file {'memcached':
    ensure => present
    path => '/etc/sysconfig/memcached,
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => 'puppet:///modules/memcached/memcached',
    require => Package['memcached'],
   }
   
   service {'memcached':
}
