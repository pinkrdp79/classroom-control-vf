class profile::base {
  #$message = hiera('message')
  notify { hiera('message':) }
}
