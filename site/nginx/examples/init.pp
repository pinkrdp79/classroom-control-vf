class nginx {
  if $facts['os']['family'] == 'windows' {
    provider => chocolatey,
  }
  
  include nginx
}
