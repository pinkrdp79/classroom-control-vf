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
    }
    'windows': {
      $package = 'nginx-service'
      $owner = 'Administrator'
      $group = 'Administrators'
      $docroot = 'C:/ProgramData/nginx/html'
      $logdir = 'C:/ProgramData/nginx/logs'
    }
    default: {
      fail("Module $(module_name) is not supported on $facts['os']['family']")
    }
  }
  
  $user = $facts['os']['family'] ? {
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
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
