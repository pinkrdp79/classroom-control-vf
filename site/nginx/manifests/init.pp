class nginx {
  $docroot = '/var/www'
  $owner = 'root'
  $group = 'root'
  $package = 'nginx'
  $service = 'nginx'
  $confdir = '/etc/nginx'
  $blockdir = "${confdir}/conf.d"

  File {
    ensure => file,
    owner => $owner,
    group => $group,
    mode => '0644',
    require => Package['nginx']
  }

  package { $package:
    ensure => present
  }
  
  file { 'docroot':
    ensure => directory,
    path => $docroot,
  }
  
  file { 'index.html':
    path => "${docroot}/index.html",
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file { 'nginx.conf':
    path => "${confdir}/nginx.conf",
    require => Package['nginx'],
    source  => 'puppet:///modules/nginx/nginx.conf',
  }
  
  file { 'default.conf':
    path => "${blockdir}/default.conf",
    require => Package['nginx'],
    source => 'puppet:///modules/nginx/default.conf',
  }
  
  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ]
  }
}
