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

package 'mariadb-server'

service 'mysqld' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

execute 'assign-root-password' do
  command "/usr/bin/mysqladmin -u root password \"#{node['mariadb']['root_password']}\""
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end
