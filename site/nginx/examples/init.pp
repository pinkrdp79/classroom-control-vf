class nginx {
case $facts['os']['family'] {
'redhat','debian' : { 
  $package = 'nginx' 
  $owner = 'root'
  $group = 'root' 
  $docroot = '/var/www' 
  $confdir = '/etc/nginx' 
  $logdir = '/var/log/nginx'
}
'windows' : {
  $package = 'nginx-service'
  $owner = 'Administrator'
  $group = 'Administrators'
  $docroot = 'C:/ProgramData/nginx/html' 
  $confdir = 'C:/ProgramData/nginx' 
  $logdir = 'C:/ProgramData/nginx/logs'
}
default : {
  fail("Module ${module_name} is not supported on ${facts['os']['family']}") 
  }
}

# user the service will run as. Used in the nginx.conf.epp template
$user = $facts['os']['family'] ? { 
'redhat' => 'nginx',
'debian' => 'www-data', 
'windows' => 'nobody',
}

File {
  owner => $owner, 
  group => $group, 
  mode => '0664',
}

package { $package: 
  ensure => present,
}

file { [ "${docroot}/vhosts", "${confdir}/conf.d" ]:
  ensure => directory, 
 }

# manage the default docroot, index, and conf--replaces several resources 
  nginx::vhost { 'default':
    docroot => $docroot,
    servername => $facts['fqdn'], 
  }

file { "${confdir}/nginx.conf":
  ensure => file,
  content => epp('nginx/nginx.conf.epp',
    {
    user => $user, 
    confdir => $confdir, 
    logdir => $logdir, 
    }),
  notify => Service['nginx'], 
 }

service { 'nginx': 
  ensure => running, 
  enable => true,
  } 
}
