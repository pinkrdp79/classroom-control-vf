class memcached {
    package {'memcached':
      ensure  => prsent,
    }
    
    file {'memcached':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/memcached/memcached',
      require => Package['memcached'],
    }
    
    service {'memcached':
      ensure    => running,
      enable    => true,
      subscribe => File['memcached'],
      }
}
