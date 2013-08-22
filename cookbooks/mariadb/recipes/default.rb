#
# Cookbook Name:: mariadb
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
node.set_unless['mariadb']['root_password'] = secure_password
node.save

package 'mariadb-server'
package 'mariadb-devel'
resources('package[mariadb-devel]').run_action(:install)
chef_gem 'mysql'

service 'mysqld' do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

execute 'assign-root-password' do
	command "/usr/bin/mysqladmin -u root password \"#{node['mariadb']['root_password']}\""
	action :run
	notifies :restart, 'service[mysqld]'
	only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

mysql_connection_info = {:host => 'localhost',
												 :username => 'root',
												 :password => node['mariadb']['root_password']}

mysql_database 'remove remote root' do
	connection mysql_connection_info
	database_name 'mysql'
	sql "DELETE FROM user WHERE user='root' AND host NOT IN ('localhost', '127.0.0.1', '::1')"
	action :query
end

mysql_database 'remove anonymous users' do
	connection mysql_connection_info
	database_name 'mysql'
	sql "DELETE FROM user WHERE user=''"
	action :query
end

mysql_database 'drop test database' do
	connection mysql_connection_info
	database_name 'mysql'
	sql "DROP DATABASE IF EXISTS test"
	action :query
end

mysql_database 'remove test database' do
	connection mysql_connection_info
	database_name 'mysql'
	sql "DELETE FROM db WHERE db='test' OR db='test\\_%'"
	action :query
end

mysql_database 'flush_privileges' do
	connection mysql_connection_info
	database_name 'mysql'
	sql 'flush privileges'
	action :query
end

