class memcached {

  package { 'memcached':
    ensure => present,
  }

  file { 'memcached':
    ensure  => file,
    path    => '/etc/sysconfig/memcached',
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    source  => 'puppet:///modules/memcached/memcached.txt',
    require => Package['memcached'],
  }
  
  service { 'memcached' :
    ensure    => running,
    enable    => true,
    subscribe => File['memcached'],
    # require => User['root'],  - cause error because root is not managed
  }
}
