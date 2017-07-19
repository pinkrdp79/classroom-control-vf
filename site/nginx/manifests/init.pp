class nginx {
  $docroot = '/var/www'
  $owner   = 'root'
  $group   = 'root'
  $package = 'nginx'
  $service = 'nginx'
  $confdir = '/etc/nginx'
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
    owner => $owner,
    group => $group,
    mode  => '0664',
  }
  
  file {'docroot':
    ensure => directory,
    path => $docroot,
  }

  file { 'index.html':                                          # use titles instead of full paths
    path => "${docroot}/index.html",
    source => 'puppet:///modules/nginx/index.html',
  }

  file { 'nginx.conf':                                           # use title
    path   => "${confdir}/nginx.conf",                            # use of namevar
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { 'default.conf':                                         # use of title
    path   => "${blockdir}/default.conf",                  # use of namevar
    source => 'puppet:///modules/nginx/default.conf',
    }

  service { 'nginx':
    ensure => running,
    enable => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],   # use of single line array, small 1 or 2 elements only
  }
}
