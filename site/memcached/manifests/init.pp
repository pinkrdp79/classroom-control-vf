class memcached {
  package { 'memcached':
    ensure => present,
  }
  
   file { 'memcached':
    ensure => file,
    path   => '/etc/sysconfig',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    source => 'puppet:///modules/memcached/memcached',
    require => Package ['memcached'],
 
  }
  
  service { 'memcached' 
    ensure => running,
    enable => true,
    require => Package ['memcached'],
    subscribe => [File['/etc/sysconfig/memcached']],
    }
    
    }
    
