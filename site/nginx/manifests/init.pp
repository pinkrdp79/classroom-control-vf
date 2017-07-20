class nginx {
  case $facts['os']['family']{
    'redhat','debian':{
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $docroot = '/var/www'
      $confdir = '/etc/nginx'
      $logdir = '/var/log/nginx'
    }
    'windows':{
      $package = 'nginx-service'
      $owner = 'Administrator'
      $group = 'Administrators'
      $docroot = 'C:/ProgramData/nginx/html'
      $confdir = 'C:/ProgramData/nginx'
      $logdir = 'C:/ProgramData/nginx/logs'
    }
    default :{
     fail("Module ${module_name} is not supported on ${facts['os']['family']}")
    }
  }

  $user = $facts['os']['family'] ? {
  'redhat' => 'nginx',
  'debian' => 'www-data',
  'windows' => 'nobody',
  }

  File {
    owner  => $owner,
    group  => $group,
    mode   => '0664, 
  }
  package { $package:
    ensure => present,
  }

  file { [ $docroot, "${confdir}/conf.d" ]:
    ensure => directory,
  }

  file { 'index.html':                                           # use titles instead of full paths
    ensure => file,
    path   => "${docroot}index.html",                             # using namevars make it easy to reference them later
    source => 'puppet:///modules/nginx/index.html',
  }

  file { 'nginx.conf':                                           # use title
    ensure => file,
    path   => "${confdir}nginx.conf",                           # use of namevar
    content => epp('nginx/nginx.conf.epp',
              {
              user => $user,
              confdir => $confdir,
              logdir => $logdir,
              }),
    notify => Service['nginx'],
  }

  file { 'default.conf':                                         # use of title
    ensure => file,
    path   => "${confdir}conf.d/default.conf",                  # use of namevar
    content => epp('nginx/default.conf.epp',
                {
                docroot => $docroot,
                }),
    notify => Service['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
  }
}
