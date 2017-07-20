class nginx (  
  String  $docroot  = $nginx::params::docroot,
  String  $owner    = $nginx::params::owner,
  String  $group    = $nginx::params::group,
  String  $package  = $nginx::params::package,
  String  $service  = $nginx::params::service,
  Integer $port     = $nginx::params::port,
  String  $confdir  = $nginx::params::confdir,
  String  $blockdir = $nginx::params::blockdir,
  String  $logdir   = $nginx::params::logdir,
  String  $user     = $nginx::params::user,
) inherits nginx::params {  
  package { $package:
    ensure => present,
    before => [                                                  
      File['index.html'],                                        
      File['nginx.conf'],                                        
      File['default.conf'],                                      
    ]                                                            
  }

  File {
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => '0664',
  }
  
  file { 'docroot':
    ensure => directory,
    path   => $docroot,
  }

  file { 'index.html':                                          
    path    => "${docroot}/index.html",                            
    content => epp('nginx/index.html.epp'),
  }

  file { 'nginx.conf':                                          
    path    => "${confdir}/nginx.conf",
    content => epp('nginx/nginx.conf.epp',
      {
        user     => $user,
        confdir  => $confdir,
        blockdir => $blockdir,
        logdir   => $logdir,
      })
  }

  file { 'default.conf':
    path    => "${blockdir}/default.conf",
    content => epp('nginx/default.conf.epp',
      {
        docroot => $docroot,
        port    => $port,
      }),
  }

  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],  
  }
}
