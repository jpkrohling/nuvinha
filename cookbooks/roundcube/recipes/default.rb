#
# Cookbook Name:: roundcube
# Recipe:: default
#
# Copyright 2013, kroehling.de
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

node.set_unless['roundcube']['database']['password'] = secure_password
node.set_unless['roundcube']['des_key'] = "#{secure_password}#{secure_password}"[0,24]
node.save

mysql_connection_info = {:host => 'localhost',
												 :username => 'root',
												 :password => node['mariadb']['root_password']}

mysql_database node['roundcube']['database']['dbname'] do
	connection mysql_connection_info
	action :create
end

mysql_database_user node['roundcube']['database']['user'] do
	connection mysql_connection_info
	password node['roundcube']['database']['password']
	database_name node['roundcube']['database']['dbname']
	host 'localhost'
	privileges [:select,:update,:insert, :delete]
	action :grant
end

package 'roundcubemail'

%w(db.inc.php main.inc.php).each do | file |
	template "/etc/roundcubemail/#{file}" do
		source "#{file}.erb"
	end
end

template '/etc/httpd/conf.d/roundcubemail.conf' do
	source 'roundcubemail.conf.erb'
	notifies :reload, 'service[httpd]'
end

# this is a bit dangerous, as it makes httpd able to open tcp connections to
# other places, but we need it in order to get it to call our own imap server...
execute '/usr/sbin/setsebool -P httpd_can_network_connect on' do
	only_if '/usr/sbin/getsebool httpd_can_network_connect | grep off'
end