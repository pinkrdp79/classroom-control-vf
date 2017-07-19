class nginx {
  package { 'nginx':
    ensure => present
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
  file { '/var/www/index.html':
    ensure => file,
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
  file { '/etc/nginx/nginx.conf':
    ensure  => file,
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
  file { '/etc/nginx/conf.d/default.conf':
    ensure => file,
    owner => 'root',
    group => 'root',
    require => Package['nginx'],
    source => 'puppet:///modules/nginx/default.conf',
  }
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/nginx/nginx.conf'],
  }
}
