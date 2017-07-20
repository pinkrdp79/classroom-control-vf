class nginx::params {
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
}
