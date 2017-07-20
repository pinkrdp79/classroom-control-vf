class nginx (
    String $package = $nginx::params::
    String $owner = $nginx::params::
    String $group = $nginx::params::
    String $confdir = $nginx::params::
    String $docroot = $nginx::params::
    String $blockdir = $nginx::params::
    String $logdir = $nginx::params::
    String $service = $nginx::params::
) inherits nginx::params {

  $runas = $facts['os']['family'] ? {
    'redhat' => 'nginx',
    'debian' => 'www-data',
    'windows' => 'nobody',
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
    content  => epp('nginx/nginx.conf.epp',
      {
        runas => $runas,
        docroot => $docroot,
        confdir => $confdir,
        logdir => $logdir,
        blockdir => $blockdir,
      }),
  }
  
  file { 'default.conf':
    path => "${blockdir}/default.conf",
    require => Package['nginx'],
    content => epp('nginx/default.conf.epp',
      {
        docroot => $docroot,
      }),
  }
  
  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ]
  }
}
