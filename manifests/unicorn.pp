##### LICENSE

# Copyright (c) Skyscrapers (iLibris bvba) 2014 - http://skyscrape.rs
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

# == Class nginx::proxy
#
# This class will install a proxy
#
define nginx::unicorn (
  $hostname                   = undef,
  $port                       = 80,
  $enable_ipv6                = false,
  $socket_path                = undef,
  $root_path                  = undef,
  $ssl_certificate            = undef,
  $ssl_certificate_key        = undef,
  $ssl_dh_param               = undef,
  $basic_authentication_file  = undef,
  $timeout                    = 20,
  ){

  if ! defined(Class['nginx']) {
    fail('You must include the nginx base class before using any nginx defined resources')
  }

  if($ssl_certificate == undef or $ssl_certificate_key == undef){
    $ssl = false
  } else {
    $ssl = true
  }

  file {
    "/etc/nginx/sites-available/${name}.conf":
      ensure   => file,
      content  => template('nginx/etc/nginx/sites-available/unicorn.conf.erb'),
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
