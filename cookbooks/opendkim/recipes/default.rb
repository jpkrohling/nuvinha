#
# Cookbook Name:: opendkim
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
package 'opendkim'

execute '/usr/sbin/opendkim-default-keygen' do
	user 'root'
	not_if { ::File.exists?('/etc/opendkim/keys/default.private') }
end

execute 'reload_systemctl' do
	command 'systemctl --system daemon-reload'
	user 'root'
	action :nothing
end

service 'opendkim' do
	supports :status => true, :restart => true, :reload => true
	action :enable
end

template '/etc/opendkim.conf' do
	source 'opendkim.conf.erb'
	notifies :restart, 'service[opendkim]'
end

template '/lib/systemd/system/opendkim.service' do
	source 'opendkim.service.erb'
	notifies :run, 'execute[reload_systemctl]', :immediately
	notifies :restart, 'service[opendkim]'
end

