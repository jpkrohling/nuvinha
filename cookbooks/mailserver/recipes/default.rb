#
# Cookbook Name:: mailserver
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

node.set_unless['mailserver']['database']['password'] = secure_password
node.save

mysql_connection_info = {:host => 'localhost',
												 :username => 'root',
												 :password => node['mariadb']['root_password']}

mysql_database node['mailserver']['database']['dbname'] do
	connection mysql_connection_info
	action :create
end

mysql_database 'create domains table' do
	connection mysql_connection_info
	database_name node['mailserver']['database']['dbname']
	sql 'CREATE TABLE IF NOT EXISTS virtual_domains (
  id int(11) NOT NULL auto_increment,
  name varchar(50) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
	action :query
end

mysql_database 'create users table' do
	connection mysql_connection_info
	database_name node['mailserver']['database']['dbname']
	sql 'CREATE TABLE IF NOT EXISTS virtual_users (
  id int(11) NOT NULL auto_increment,
  domain_id int(11) NOT NULL,
  password varchar(106) NOT NULL,
  email varchar(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY email (email),
  FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
	action :query
end

mysql_database 'create aliases table' do
	connection mysql_connection_info
	database_name node['mailserver']['database']['dbname']
	sql 'CREATE TABLE IF NOT EXISTS virtual_aliases (
  id int(11) NOT NULL auto_increment,
  domain_id int(11) NOT NULL,
  source varchar(100) NOT NULL,
  destination varchar(100) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
	action :query
end

mysql_database_user node['mailserver']['database']['user'] do
	connection mysql_connection_info
	password node['mailserver']['database']['password']
	database_name node['mailserver']['database']['dbname']
	host 'localhost'
	privileges [:select,:update,:insert]
	action :grant
end
