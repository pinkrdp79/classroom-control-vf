class users::admins {
  $user = ['joe', 'alice', 'aaron' ]
  
  users::managed_user {$user:
    ensure => present,
    group => 'staff',
    }

   group {'staff':
     ensure => present,
   }
 }
