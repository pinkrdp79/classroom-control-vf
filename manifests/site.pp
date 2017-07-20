## site.pp ##

File { backup => false }

# Randomize enforcement order to help understand relationships
ini_setting { 'random ordering':
  ensure  => present,
  path    => "${settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'ordering',
  value   => 'title-hash',
}

#node josephoaks.puppetlabs.vm {
#  if $facts['virtual'] == 'docker' {
#    $vmname = $facts['virtual']
#    notify { "This is a ${vmname} machine.": }
#  }
#}

node default {
  include role::classroom
  
  #file { 'motd':
  #  ensure  => file,
  #  path    => '/etc/motd',
  #  owner   => 'root',
  #  group   => 'root',
  #  content => "Isn't Puppet fun!\n",
  #}
  
  exec { 'motd':
    command => "cowsay 'Welcome to $fqdn!' > /etc/motd",
    path    => '/usr/local/bin',
    creates => '/etc/motd',
  } 
}
