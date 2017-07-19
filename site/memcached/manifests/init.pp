class memcached {
  package {'memcached':
    ensure => 'present',
  }
  
  file {'memcached.conf':
    ensure => 'file',
    path   => '',
    source => '',
  }
  
  service {'memcached.conf':
    ensure = 'running',
    subscribe => File['memcached.conf'],
  }
  
}
