class role::blog {
  #web server / php
  include profile::apache

  include profile::wordpress
  include profile::mysql
}
