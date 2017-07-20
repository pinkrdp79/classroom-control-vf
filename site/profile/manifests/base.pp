class profile::base {
  $message = hiera('message')
  notify { $message: }
  # notify { "Hello, my new name is ${::hostname}": }
}
