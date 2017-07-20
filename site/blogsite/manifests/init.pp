class blogsite {
  user { 'wordpress':
    ensure     => present,
    managehome => true,
  }
  class { 'wordpress':
  wp_owner    => 'wordpress',
  wp_group    => 'wordpress',
  db_user     => 'wordpress',
  db_password => 'puppetlabs',
}
}
