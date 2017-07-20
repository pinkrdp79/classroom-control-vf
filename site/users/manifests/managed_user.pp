define users::managed_user (
  $group = $title,
){
  $home = $facts['os']['family'] ? {
    'windows' => 'C:/Users',
    default   => '/home',
  }
  
  user { $title:
    ensure     => present,
    managehome => true,
  }

  file { "${home}/${title}":
    ensure => directory,
    owner  => $title,
    group  => $group,
  }
  
  file { "${home}/${title}/.ssh":
    ensure => directory,
    owner  => $title,
    group  => $group,
    mode   => '0700',
  }
}
