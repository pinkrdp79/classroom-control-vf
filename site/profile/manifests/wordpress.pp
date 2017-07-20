class profile::wordpress {
  class { 'wordpress':
    install_dir => '/var/www/wp'
  }
}
