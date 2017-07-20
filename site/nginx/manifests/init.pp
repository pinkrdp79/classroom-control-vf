class nginx (  
  String  $docroot  = $nginx::params::docroot,
  String  $owner    = $nginx::params::owner,
  String  $group    = $nginx::params::group,
  String  $package  = $nginx::params::package,
  String  $service  = $nginx::params::service,
  Integer $port     = $nginx::params::port,
  String  $confdir  = $nginx::params::confdir,
  String  $blockdir = $nginx::params::blockdir,
  String  $logdir   = $nginx::params::logdir,
  String  $user     = $nginx::params::user,
) inherits nginx::params {  
  include nginx::packages
  include nginx::config
  include nginx::services
}
