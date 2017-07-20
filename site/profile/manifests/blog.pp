#web server/php 


class { 'apache':
docroot => '/var/www',
}

class {'apache'::mod::php':
}
#db server
class { 'mysql::server':
root_password=> 'blahblah'
}
class { 'mysql::bindings':
php_enable => true,
}
#bloggin platform
class { 'wordpress':
install_dir => '/var/www/wp',
}
