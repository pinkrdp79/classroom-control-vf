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
    require => package ['memcached'],
 
  }
  
  service { 'memcached' 
    ensure => running,
    enable => true,
    require => package ['memcached'],
    }
    
    }
    
