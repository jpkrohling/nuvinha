#
# Cookbook Name:: apache
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

%w(httpd-2.4.6-3.fc19.x86_64.rpm httpd-tools-2.4.6-3.fc19.x86_64.rpm mod_ssl-2.4.6-3.fc19.x86_64.rpm).each do | file |
	cookbook_file file do
		backup false
		path "/tmp/#{file}"
		action :create_if_missing
	end
end

# dirty hack, as all of these packages needs to be installed together, due to the dependencies
execute 'yum install -y /tmp/httpd*.rpm /tmp/mod_*.rpm' do
	not_if 'test $(rpm -q httpd) = "httpd-2.4.6-3.fc19.x86_64"'
end

service 'httpd' do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

%w(ssl ssl-only).each do | file |
	template "/etc/httpd/conf.d/#{file}.conf" do
		source "#{file}.conf.erb"
		notifies :reload, 'service[httpd]'
	end
end

