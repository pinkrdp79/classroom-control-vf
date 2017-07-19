class nginx {
  package { 'nginx':
    ensure => present,
    before => [
      File['index.html'],
      File['nginx.conf'],
      File['default.conf']
    ]
  }
  user { 'nginx':
    ensure => present,
  }
  file { '/var/www':
    ensure => directory,
    owner => 'nginx',
    group => 'nginx',
    mode => '0755',
  }
  file { 'index.html':
    ensure => file,
    path => '/var/www/index.html',
    owner => 'nginx',
    group => 'nginx',
    mode => '0644',
    source => 'puppet:///modules/nginx/index.html',
  }
  file { '/etc/nginx':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0755',
  }
  file { 'nginx.conf':
    ensure  => file,
    path => '/etc/nginx/nginx.conf',
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
    source  => 'puppet:///modules/nginx/nginx.conf',
  }
  file { '/etc/nginx/conf.d':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0755',
  }
  file { 'default.conf':
    ensure => file,
    path => '/etc/nginx/conf.d/default.conf',
    owner => 'root',
    group => 'root',
    require => Package['nginx'],
    source => 'puppet:///modules/nginx/default.conf',
  }
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ]
  }
}
