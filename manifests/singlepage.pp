# == Class nginx::singlepage
#
define nginx::singlepage (
  $root_path               = undef,
  $log_path                = '/var/log/nginx',
  $log_format              = undef,
  $port                    = 80,
  $enable_ipv6             = false,
  $http_auth               = false,
  $server_aliases          = [],
  $client_max_body_size    = '1m',
  $ssl_certificate         = undef,
  $ssl_certificate_key     = undef,
  $ssl_dh_param            = undef,
  $https_redirect          = false,
  $optional_lines          = [],
  $etag                    = false,
  $manage_letsencrypt_root = false,
  $http2                   = false,
){

  if ! defined(Class['nginx']) {
    fail('You must include the nginx base class before using any nginx defined resources')
  }

  if($ssl_certificate == undef or $ssl_certificate_key == undef){
    $ssl = false
  } else {
    $ssl = true
  }

  if $manage_letsencrypt_root {
    $letsencrypt_root = "/var/www/letsencrypt-${name}"
    file {
      $letsencrypt_root:
        ensure => directory,
        mode   => '0755',
        owner  => root,
        group  => www-data,
    }
  }

  file {
    "/etc/nginx/sites-available/${name}.conf":
      ensure   => file,
      content  => template('nginx/etc/nginx/sites-available/singlepage.conf.erb'),
      mode     => '0644',
      owner    => root,
      group    => root,
      require  => Class['nginx::install'],
      notify   => Class['nginx::service'];

    "/etc/nginx/sites-enabled/${name}.conf":
      ensure  => link,
      target  => "/etc/nginx/sites-available/${name}.conf",
      require => File["/etc/nginx/sites-available/${name}.conf"],
      notify  => Class['nginx::service'];
  }
}
