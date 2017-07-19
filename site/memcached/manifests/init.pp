class memcached {
    package {'memcahed':
      ensure  => prsent,
    }
    
    file {'/etxc/sysconfig/memcahed':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/memcahed/memcached',
      require => Package['memcached'],
    }
    
    service {'memcached':
      ensure  => running,
      enable  => true,
      subscribe => File['/etc/sysconfig/memcached'],
      }
}
