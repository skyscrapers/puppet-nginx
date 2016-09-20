##### LICENSE

# Copyright (c) Skyscrapers (iLibris bvba) 2015 - http://skyscrapers.eu
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# == Class nginx::redirect
#
# This class redirects a request
#
# == Variables
#
# $server_name
# server name to listen for eg 'example.com'
#
# $target
# target base url to redirect to eg: 'https://example.com'
#
# $ip (optional)
# ip to listen on. eg: '*'
#
# $port (optional)
# port to listen on. defaults to 80 if not defined or 443 if ssl is used
# example: '8080'
#
# $server_aliases (optional)
# list of server aliases eg: ['www.example.com', 'www2.example.com']
#
# $ssl_certificate $ssl_certificate_key
# if using ssl, the path to the certificate and certificate key file
# if these variables are both set, $ssl is set to TRUE
# eg: '/etc/nginx/ssl/example.com.pem'
#
# example usage
# nginx::redirect{'example-redirect':
#   server_name     => 'example.com',
#   target => 'anotherexample.com',
# }
##

define nginx::redirect (
    $server_name,
    $target,
    $ip = '',
    $ipv6 = '::',
    $port = undef,
    $enable_ipv6 = false,
    $server_aliases = [],
    $ssl_certificate = undef,
    $ssl_certificate_key = undef,
    $ssl_dh_param = undef,
  ) {

  if($ssl_certificate == undef or $ssl_certificate_key == undef){
    $ssl = false
  } else {
    $ssl = true
  }

  if($ssl and $port == undef){
    $_port = '443'
  } elsif(!$ssl and $port == undef) {
    $_port = '80'
  } else {
    $_port = $port
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
