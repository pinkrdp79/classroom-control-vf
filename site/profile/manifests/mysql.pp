class profile::mysql {
  class { 'mysql::server':
    root_password => hiera('mysql_pw'),
    remove_default_accounts => true,
  }

  class { 'mysql::bindings':
    php_enable => true
  }
}
