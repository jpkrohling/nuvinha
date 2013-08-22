#
# Cookbook Name:: postfix
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
package 'postfix'

service 'postfix' do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

template '/etc/postfix/main.cf' do
	source 'main.cf.erb'
	notifies :restart, 'service[postfix]'
end

%w(alias-maps mailbox-domains mailbox-maps).each do | file |
	template "/etc/postfix/mysql-virtual-#{file}.cf" do
		source "mysql-virtual-#{file}.cf.erb"
		notifies :restart, 'service[postfix]'
	end
end

link '/etc/alternatives/mta' do
	to '/usr/sbin/sendmail.postfix'
end

link '/etc/alternatives/mta-sendmail' do
	to '/usr/sbin/sendmail.postfix'
end