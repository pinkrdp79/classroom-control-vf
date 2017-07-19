class memcached {
  package { 'memcached':
    ensure => present,
    before => [                                                  # Break arrays up into multiple                                        
      File['memcached.conf'],                                      # makes it easier to add new
    ]                                                            # elements and easier to read.
  }
  
   file { 'memcached.conf':
    ensure => file,
    path   => '/etc/sysconfig',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
 
  }
