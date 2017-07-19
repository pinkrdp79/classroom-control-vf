class nginx {
  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  
  package { 'nginx':
    ensure => present,
    before => [                                                 # Break arrays up into multiple
      File['index.html'],                                       # lines as to not go beyond the
      File['nginx.conf'],                                       # 80 characters per line and it
      File['default.conf'],                                     # makes it easier to add new
    ]                                                           # elements and easier to read.
  }
  
  file { 'docroot':
    ensure => directory,
    path   => '/var/www',
    mode   => '0755',
  }
  
  file { 'index.html':                                          # use titles instead of full paths
    path   => '/var/www/index.html',                            # using namevars make it easy to reference them later
    source => 'puppet:///modules/nginx/index.html',
  }

  file { 'nginx.conf':                                           # use title
    path   => '/etc/nginx/nginx.conf',                            # use of namevar
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { 'default.conf':                                         # use of title
    path   => '/etc/nginx/conf.d/default.conf',                  # use of namevar
    source => 'puppet:///modules/nginx/default.conf',
  }

  service { 'nginx':
    ensure => running,
    enable => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],   # use of single line array, small 1 or 2 elements only
  }
}
