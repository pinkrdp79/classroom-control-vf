class users::admins {
   $user = ['alice','chen',joe']
   
users::manage {$user:
  ensure => present,
  group  => 'staff',
}

group { 'staff':
   ensure => present,
  }
}

