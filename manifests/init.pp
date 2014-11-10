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

##### PARAMETERS WITH DEFAULTS

# $nginxtype: 'nginx-light' (default), 'nginx-extras', 'nginx-full'
#
# USAGE
#
# class {'nginx': }
# class {'nginx': nginxtype => 'nginx-extras', }
#
# NOTE
# Ubuntu 10.04 only has package 'nginx', so $nginxtype will be ignored
#
# More information on the difference between nginx-light, nginx-extras and nginx-full
# -> https://wiki.debian.org/Nginx
#
# CONFIG
# Most configuration (almost all) is done in the vhosts (other module)

class nginx ($nginxtype = $nginx::params::nginxtype) inherits nginx::params {

  class { '::nginx::install': } ->
  class { '::nginx::config': } ~>
  class { '::nginx::service': }

}
