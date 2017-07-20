class profile::blog {

  class { 'wordpress': }
  wp_debug => true,

}
