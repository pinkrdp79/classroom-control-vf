class nginx {
  $owner  = 'root'
  $group  = 'root'
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

  file { 'docroot':
    ensure => directory,
    path   => '/var/www',
    mode   => '0755',
  }
  
  file { 'index.html':                                          
    ensure => file,
    path   => '/var/www/index.html',                            
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
