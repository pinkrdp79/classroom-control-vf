class nginx::packages inherits nginx::params {
  package { $package:
    ensure => present,
    before => [                                                  
      File['index.html'],                                        
      File['nginx.conf'],                                        
      File['default.conf'],                                      
    ]                                                            
  }
}
