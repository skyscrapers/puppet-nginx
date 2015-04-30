## DOCUMENTATION
#
# generate redirect vhost for nginx
#
##
define nginx::redirect (
    $server_name,
    $target,
    $ip = '*',
    $port = undef,
    $server_aliases = [],
    $ssl_certificate = undef,
    $ssl_certificate_key = undef,
  ) {

  if($ssl_certificate == undef or $ssl_certificate_key == undef){
    $ssl = false
  } else {
    $ssl = true
  }

  if($ssl and $port == undef){
    $port = '443'
  } elsif(!$ssl and $port == undef) {
    $port = '80'
  }

  file {
    "/etc/nginx/sites-available/${name}.conf":
      path    => "/etc/nginx/sites-available/${name}.conf",
      content => template('nginx/etc/nginx/sites-available/redirect.conf.erb'),
      mode    => '0644',
      owner   => root,
      group   => root,
      require => Class['nginx::install'],
      notify  => Class['nginx::service'];

    "/etc/nginx/sites-enabled/${name}.conf":
      ensure  => link,
      target  => "/etc/nginx/sites-available/${name}.conf",
      require => File["/etc/nginx/sites-available/${name}.conf"],
      notify  => Class['nginx::service'];
  }
}
