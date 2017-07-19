class nginx {
  $docroot = '/var/www'
  $nginx_source = 'puppet:///modules/nginx'

  File {
    ensure => file
    owner => 'root',
    group => 'root',
    mode => '0664',
  }

  package { 'nginx':
    ensure => present,
    before => [
      File['index.html'],
      File['nginx.conf'],
      File['default.conf'],
    ]
  }

  file { 'docroot':
    ensure => directory,
    path   => $docroot,
    mode   => '0755',
  }

  file { 'index.html':
    path   => "${docroot}/index.html",
    source => "${nginx_source}/index.html",
  }

  file { 'nginx.conf':
    path   => '/etc/nginx/nginx.conf',
    source => "${nginx_source}/nginx.conf",
  }

  file { 'default.conf':
    path   => '/etc/nginx/conf.d/default.conf',
    source => "${nginx_source}/default.conf",
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],
  }
}
