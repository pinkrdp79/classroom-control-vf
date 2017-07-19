class nginx {
  file {
    owner => 'root',
    group => 'root',
  }
  package { 'nginx':
    ensure => present,
    before => [                                                  
      File['index.html','nginx.conf','default.conf'],                                                                              
    ]                                                            
  }

  file { 'docroot':
    ensure => directory,
    path   => '/var/www',
    mode   => '0755',
  }

  file { 'index.html':                                           
    ensure => file,
    path   => '/var/www/index.html',                             
    mode   => '0664',
    source => 'puppet:///modules/nginx/index.html',
  }

  file { 'nginx.conf':                                           
    ensure => file,
    path   => '/etc/nginx/nginx.conf',                           
    mode   => '0664',
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { 'default.conf':                                         
    ensure => file,
    path   => '/etc/nginx/conf.d/default.conf',                  
    mode   => '0664',
    source => 'puppet:///modules/nginx/default.conf',
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],   
  }
}
