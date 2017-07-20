class nginx (
    String $package = $nginx::params::package,
    String $owner = $nginx::params::owner,
    String $group = $nginx::params::group,
    String $confdir = $nginx::params::confdir,
    String $docroot = $nginx::params::docroot,
    String $blockdir = $nginx::params::blockdir,
    String $logdir = $nginx::params::logdir,
    String $service = $nginx::params::service,
    String $runas = $nginx::params::runas,
    String $port = $nginx::params::port,
) inherits nginx::params {    
    include nginx::packages
    include nginx::config
    include nginx::services
}
