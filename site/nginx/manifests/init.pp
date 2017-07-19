
class nginx {
  $docroot  = '/var/www'
  $owner    = 'root'
  $group    = 'root'
  $package  = 'nginx'
  $service  = 'nginx'
  $confdir  = '/etc/nginx'
  $blockdir = "${confdir}/conf.d"
  
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
    path   => "${docroot}/index.html",                            
    source => 'puppet:///modules/nginx/index.html',
  }

  file { 'nginx.conf':                                          
    path   => "${confdir}/nginx.conf",                          
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { 'default.conf':                                        
    path   => "${blockdir}/default.conf",                 
    source => 'puppet:///modules/nginx/default.conf',
  }

  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],  
  }
}
