#
# Cookbook Name:: owncloud
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

node.set_unless['owncloud']['database']['password'] = secure_password
node.set_unless['owncloud']['salt'] = secure_password
node.save

include_recipe 'owncloud::storage'
package 'owncloud-mysql'

mysql_connection_info = {:host => 'localhost',
												 :username => 'root',
												 :password => node['mariadb']['root_password']}

mysql_database node['owncloud']['database']['dbname'] do
	connection mysql_connection_info
	action :create
end

mysql_database_user node['owncloud']['database']['user'] do
	connection mysql_connection_info
	password node['owncloud']['database']['password']
	database_name node['owncloud']['database']['dbname']
	host 'localhost'
	privileges [:select,:update,:insert, :delete]
	action :grant
end

template '/etc/httpd/conf.d/owncloud.conf' do
	source 'owncloud.conf.erb'
	notifies :reload, 'service[httpd]'
end
