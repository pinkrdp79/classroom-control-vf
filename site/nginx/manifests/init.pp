class nginx (
String $root = undef,
) {
  $owner  = 'root'
  $group  = 'root'
  $defdocroot = '/var/www',
  #$mysource = 'puppet:///modules/nginx'
  $mode   = '0664'

  package { 'nginx':
    ensure => present,
    before => [                                                 
      File['index.html'],                                       
      File['nginx.conf'],                                       
      File['default.conf'],                                     
    ]                                                           
  }
class nginx (
  String $root = undef,
) {
  case $facts['os']['family'] {
    'redhat' : {  
      $def_docroot  = '/var/www'
      $owner    = 'root'
      $group    = 'root'
      $package  = 'nginx'
      $service  = 'nginx'
      $port     = '80'
      $confdir  = '/etc/nginx'
      $blockdir = "${confdir}/conf.d"
      $logdir   = '/var/log/nginx'
    }
    'windows' : {
      $docroot  = 'C:/ProgramData/nginx/html'
      $owner    = 'Administrator'
      $group    = 'Administrators'
      $package  = 'nginx'
      $service  = 'nginx'
      $port     = '80'
      $confdir  = 'C:/ProgramData/nginx'
      $blockdir = "${confdir}/conf.d"
      $confdir  = 'C:/ProgramData/nginx/logs'
    }
    default : {
      fail("${module_name} is not support on ${facts['os']['family']}")
    }
  }
  
  $docroot = $root ? {
    undef   => $def_docroot,
    default => $root,
  }
  
  $user = $facts['os']['family'] ? {
    'windows' => 'nobody',
    default  => 'nginx',
  }
  
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
    #source => 'puppet:///modules/nginx/index.html',
    content => epp('nginx/index.html.epp'),
  }

  file { 'nginx.conf':                                          
    path    => "${confdir}/nginx.conf",
    #source => 'puppet:///modules/nginx/nginx.conf',
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
    #source => 'puppet:///modules/nginx/default.conf',
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
$docroot = $root ? {
  undef => $docroot,
  $docroot => $defdocroot, 
}
  file { 'docroot':
    ensure => directory,
    path   => $docroot,
    mode   => '0755',
  }
  
  file { 'index.html':                                          
    ensure => file,
    path   => '$docroot/index.html',                            
    source => 'puppet:///modules/nginx/index.html',
  }

  file { 'nginx.conf':                                           
    ensure => file,
    path   => '/etc/nginx/nginx.conf',                           
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { 'default.conf':                                         
    ensure => file,
    path   => '/etc/nginx/conf.d/default.conf',                  
    source => 'puppet:///modules/nginx/default.conf',
  }

  service { 'nginx':
    ensure => running,
    enable => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],   # use of single line array, small 1 or 2 elements only
  }
}
