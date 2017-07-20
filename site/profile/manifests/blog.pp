class profile::blog{
  include apache
  include 'apache::mod:php'
  include 'mysql::server'
  include wordpress
}
