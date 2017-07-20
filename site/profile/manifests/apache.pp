class profile::wordpress { 'wordpress' :
    ensure => present,
    notify { 'This is the example profile!': },
    }
class profile::apache { 'apache' : }
