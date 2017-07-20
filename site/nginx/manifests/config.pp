class nginx::config inherits nginx::params {
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
    path    => "${docroot}/index.html",                            
    content => epp('nginx/index.html.epp'),
  }
