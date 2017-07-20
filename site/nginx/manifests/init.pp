class nginx {
  $docroot  = '/var/www'
  $owner    = 'root'
  $group    = 'root'
  $package  = 'nginx'
  $service  = 'nginx'
  $confdir  = '/etc/nginx'
  $blockdir = "${confdir}/conf.d"
  
  case $facts['os']['family'] {
    'redhat','debian': {
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $docroot = '/etc/nginx'
      $logdir = '/var/log/nginx'
      $confdir = '/etc/nginx'
      $blockdir = '${confdir}/conf.d'
    }
    'windows': {
      $package = 'nginx-service'
      $owner = 'Administrator'
      $group = 'Administrators'
      $docroot = 'C:/ProgramData/nginx/html'
      $logdir = 'C:/ProgramData/nginx/logs'
      $confdir = 'C:/ProgramData/nginx/logs'
      $blockdir = '${confdir}/conf.d'
    }
    default: {
      fail("Module $(module_name) is not supported on $facts['os']['family']")
    }
  }
  
  $user = $facts['os']['family'] ? {
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
    default   => 'nginx',
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
  
  file { [$docroot,"${confdir}/conf.d]:
    ensure => directory,
    path   => $docroot,
  }

  file { "${docroot}/index.html":                                          
    path   => "${docroot}/index.html",                            
    #source => 'puppet:///modules/nginx/index.html',
    content => cpp{'ngix/index.html.epp'}
  }

  file { "${confdir}/nginx.conf":                                          
    path    => "${confdir}/nginx.conf",                          
    source  => 'puppet:///modules/nginx/nginx.conf',
    content => epp('nginx/nginx.conf.epp',
        {
         user     => $user,
         confdir  => $confdir,
         logdir   => $logdir,
        } ),
     notify  => Service['nginx'],
  }

  file { "${confdir}/default.conf":                                        
    path   => "${blockdir}/default.conf",                 
    source => 'puppet:///modules/nginx/default.conf',
    content => epp('nginx/default.conf.epp',
                 {
                  docroot  => $docroot,
                 } ),
     notify => Service['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],  
  }
}
