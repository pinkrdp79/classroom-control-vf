class nginx {
  case $facts['os']['family'] {
    'redhat','debian' : {  
      $docroot  = '/var/www'
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
