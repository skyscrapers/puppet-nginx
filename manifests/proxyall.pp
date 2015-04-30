## DOCUMENTATION
#
# generate redirect vhost for nginx
#
##
define nginx::proxyall (
    $port,
    $target,
  ) {

  file {
    "/etc/nginx/sites-available/${name}.conf":
      path    => "/etc/nginx/sites-available/${name}.conf",
      content => template('nginx/etc/nginx/sites-available/proxy-all.conf.erb'),
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
