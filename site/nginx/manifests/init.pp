class nginx {

  $docroot  = '/var/www'
  $ngxdir   = '/etc/nginx'
  $pupfiles = 'puppet:///modules/nginx'
  
  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
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
    path   => $docroot,
    mode   => '0755',
  }
  
  file { 'index.html':                                          # use titles instead of full paths
    path   => "${docroot}/index.html",                            # using namevars make it easy to reference them later
    source => "${pupfiles}/index.html",
  }

  file { 'nginx.conf':                                           # use title
    path   => "${ngxdir}/nginx.conf",                            # use of namevar
    source => "${pupfiles}/nginx.conf",
  }

  file { 'default.conf':                                         # use of title
    path   => "${ngxdir}/conf.d/default.conf",                  # use of namevar
    source => "${pupfiles}/default.conf",
  }

  service { 'nginx':
    ensure => running,
    enable => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],   # use of single line array, small 1 or 2 elements only
  }
}
