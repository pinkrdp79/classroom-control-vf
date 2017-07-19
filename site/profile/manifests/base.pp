class profile::base {
  notify { "Hello, my new name is ${::hostname}": }
}
