class profile::base {
  $message = hiera('message')
  notify { "Hello, my name is ${::hostname}": }
}
