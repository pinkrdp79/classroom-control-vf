class nginx::services inherits nginx::params {
  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [ File['nginx.conf'], File['default.conf'] ],  
  }
}
