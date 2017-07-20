class profile::mysql {
  class { '::mysql::server':
    root_password => hieradata('mysql_pw'),
    remove_default_accounts => true,
  }
}
