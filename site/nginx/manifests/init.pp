class nginx {
  case $facts['os']['family'] {
    'windows' : {
      $package => 'nginx-service',
      $owner => 'Administrator',
      $group => 'Administrators',
      $confdir => 'C:/ProgramData/nginx',
      $docroot => "${confdir}/html",
      $blockdir => "${confdir}/conf.d",
      $logsdir => "${confdir}/logs",
      $service => 'nginx',
      $runas => 'nobody'
    }
    'redhat', 'debian' : {
      $package => 'nginx',
      $owner => 'root',
      $group => 'root',
      $confdir => '/etc/nginx',
      $docroot => '/var/www',
      $blockdir => "${confdir}/conf.d",
      $service => 'nginx',
      if $facts['os']['family'] == 'debian' {
        $runas => 'www-data',
      } else {
        $runas => 'nginx'
      }
    }
  }

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
