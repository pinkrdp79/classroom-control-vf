class memcached {
  package {'memcached'
    ensure => 'present',
  }
  
  file {'memcached.conf'
    ensure => 'present',
  }
  
  service {'memcached.conf'
    ensure = 'running',
    subscribe => File['memcached.conf'],
  }
  
}
