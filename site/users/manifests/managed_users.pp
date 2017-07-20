define users::managed_users (
    $group = $title,
  ) {
    user { $title:
    ensure => present,
  }
  file { "/home/${title}":
    ensure => directory,
    owner => $title,
    group => $group,
  }
}
