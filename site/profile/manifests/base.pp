class profile::base {
  notify { "Hello, I'll be back ${::hostname}": }
}
