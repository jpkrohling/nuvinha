#
# Cookbook Name:: dovecot
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
package 'dovecot'
package 'dovecot-pigeonhole'
package 'dovecot-mysql'

service 'dovecot' do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

%w(dovecot.conf dovecot-sql.conf.ext).each do | file |
	template "/etc/dovecot/#{file}" do
		source "#{file}.erb"
		notifies :restart, 'service[dovecot]'
	end
end

template '/etc/dovecot/conf.d/auth-sql.conf.ext' do
	source 'auth-sql.conf.ext.erb'
	notifies :restart, 'service[dovecot]'
end

%w(10-auth 10-mail 10-master 10-ssl 15-lda 20-imap 20-lmtp 20-managesieve 90-sieve).each do | file |
	template "/etc/dovecot/conf.d/#{file}.conf" do
		source "#{file}.conf.erb"
		notifies :restart, 'service[dovecot]'
	end
end