class users::admins {
  $user = ['joe', 'alice', 'aaron' ]
  
  users::managed_user {$user:
    group => 'staff',
    }

   group {'staff':
     ensure => present,
   }
 }
