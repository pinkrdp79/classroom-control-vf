class nginx {
  $docroot = '/var/www/'
  $confroot = '/etc/nginx/'
  $owner = 'root'
  $group = 'root'
  $mode = '0664'
  
  File {
    owner  => $owner,
    group  => $group,
    mode   => $mode, 
  }
  package { 'nginx':
    ensure => present,
    before => [                                                  # Break arrays up into multiple
      File['index.html'],                                        # lines as to not go beyond the
      File['nginx.conf'],                                        # 80 characters per line and it
      File['default.conf'],                                      # makes it easier to add new
    ]                                                            # elements and easier to read.
  }

  file { 'docroot':
    ensure => directory,
    path   => "${docroot}",
    mode   => '0755',
  }

  file { 'index.html':                                           # use titles instead of full paths
    ensure => file,
    path   => "${docroot}index.html",                             # using namevars make it easy to reference them later
    source => 'puppet:///modules/nginx/index.html',
  }

  file { 'nginx.conf':                                           # use title
    ensure => file,
    path   => "${confroot}nginx.conf",                           # use of namevar
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { 'default.conf':                                         # use of title
    ensure => file,
    path   => "${confroot}conf.d/default.conf",                  # use of namevar
    source => 'puppet:///modules/nginx/default.conf',
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],   # use of single line array, small 1 or 2 elements only
  }
}
