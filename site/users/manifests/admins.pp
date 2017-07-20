class users::admins {
  $user = [ 'alice', 'chen', 'jose' ]

  users::managed_user { $user:
    #ensure => present,
    group  => 'staff',
  }
  
  group { 'staff':
    ensure => present,
  }
}
