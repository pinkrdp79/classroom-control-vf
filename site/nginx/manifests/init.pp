class nginx (
    String $package = $nginx::params::package,
    String $owner = $nginx::params::owner,
    String $group = $nginx::params::group,
    String $confdir = $nginx::params::confdir,
    String $docroot = $nginx::params::docroot,
    String $blockdir = $nginx::params::blockdir,
    String $logdir = $nginx::params::logdir,
    String $service = $nginx::params::service,
    String $runas = $nginx::params::runas,
) inherits nginx::params {

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
