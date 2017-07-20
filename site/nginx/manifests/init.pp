class nginx {
  case $facts['os']['family'] {
    'redhat','debian': {
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $confdir = '/etc/nginx'
      $docroot = '/var/www'
      $blockdir = "${confdir}/conf.d"
      $logdir = '/var/log/nginx'
      $service = 'nginx'
    }
    'windows': {
      $package = 'nginx-service'
      $owner = 'Administrator'
      $group = 'Administrators'
      $confdir = 'C:/ProgramData/nginx'
      $docroot = "${confdir}/html"
      $blockdir = "${confdir}/conf.d"
      $logdir = "${confdir}/logs"
      $service = 'nginx'
    }
    default :{
      fail("Module ${module_name} is not supported on ${facts['os']['family']}")
    }
  }  
  
  $runas = $facts['os']['family'] ? {
    'redhat' => 'nginx',
    'debian' => 'www-data',
    'windows' => 'nobody',
  }

  File {
    ensure => file,
    owner => $owner,
    group => $group,
    mode => '0644',
    require => Package['nginx']
  }

  package { $package:
    ensure => present
  }
  
  file { 'docroot':
    ensure => directory,
    path => $docroot,
  }
  
  file { 'index.html':
    path => "${docroot}/index.html",
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file { 'nginx.conf':
    path => "${confdir}/nginx.conf",
    require => Package['nginx'],
    content  => epp('nginx/nginx.conf.epp',
      {
        runas => $runas,
        docroot => $docroot,
        confdir => $confdir,
        logdir => $logdir,
        blockdir => $blockdir,
      }),
  }
  
  file { 'default.conf':
    path => "${blockdir}/default.conf",
    require => Package['nginx'],
    content => epp('nginx/default.conf.epp',
      {
        docroot => $docroot,
      }),
  }
  
  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ]
  }
}
