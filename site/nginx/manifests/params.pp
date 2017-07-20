class nginx::params {
  case $facts['os']['family'] {
    'redhat' : {  
      $docroot  = '/var/www'
      $owner    = 'root'
      $group    = 'root'
      $package  = 'nginx'
      $service  = 'nginx'
      $port     = 80
      $confdir  = '/etc/nginx'
      $blockdir = "${confdir}/conf.d"
      $logdir   = '/var/log/nginx'
    }
    'windows' : {
      $docroot  = 'C:/ProgramData/nginx/html'
      $owner    = 'Administrator'
      $group    = 'Administrators'
      $package  = 'nginx'
      $service  = 'nginx'
      $port     = 80
      $confdir  = 'C:/ProgramData/nginx'
      $blockdir = "${confdir}/conf.d"
      $confdir  = 'C:/ProgramData/nginx/logs'
    }
    default : {
      fail("${module_name} is not support on ${facts['os']['family']}")
    }
  }
  
  $user = $facts['os']['family'] ? {
    'windows' => 'nobody',
    default  => 'nginx',
  }
}
