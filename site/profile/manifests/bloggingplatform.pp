class profile::bloggingplatform {
  include apache
  include '::mysql::server'
  include wordpress
  
  class { 'apache': }
  
  class { 'wordpress': }
}
