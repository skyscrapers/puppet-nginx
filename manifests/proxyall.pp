##### LICENSE

# Copyright (c) Skyscrapers (iLibris bvba) 2015 - http://skyscraper.eu
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

# == Class nginx::proxyall
#
# This class will proxy all requests on a port to a target
#
define nginx::proxyall (
    $port,
    $target,
  ) {

  file {
    "/etc/nginx/sites-available/${name}.conf":
      path    => "/etc/nginx/sites-available/${name}.conf",
      content => template('nginx/etc/nginx/sites-available/proxyall.conf.erb'),
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
