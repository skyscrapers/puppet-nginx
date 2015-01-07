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

class nginx::config {

  file {
    # VHOST FOR STATS
    '/etc/nginx/sites-available/status':
      ensure => file,
      source => 'puppet:///modules/nginx/etc/nginx/sites-available/status',
      mode   => '0644',
      owner  => root,
      group  => root,
      notify => Class['nginx::service'];

    '/etc/nginx/sites-enabled/status':
      ensure  => target,
      target  => '/etc/nginx/sites-available/status',
      require => File['/etc/nginx/sites-available/status'],
      notify  => Class['nginx::service'];
  }

  if( $nginx::passenger == true ){
    file {
      '/etc/nginx/nginx.conf':
      ensure => file,
      source => 'puppet:///modules/nginx/etc/nginx/nginx-passenger.conf',
      mode => '0644',
      owner => root,
      group => root,
      notify => Class['nginx::service'];
    }
  }

}
