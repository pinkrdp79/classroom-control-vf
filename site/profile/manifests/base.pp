class profile::base {
  $message = hiera($message)
  
  notify { "From ${message}" }
  
}
