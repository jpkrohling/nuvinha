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

package 'httpd'
package 'mod_ssl'

service 'httpd' do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

%w(ssl ssl-only).each do | file |
	template "/etc/httpd/conf.d/#{file}.conf" do
		source "#{file}.conf.erb"
		notifies :restart, 'service[httpd]'
	end
end

