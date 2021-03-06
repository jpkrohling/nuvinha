#
# Cookbook Name:: base
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

package 'screen'
package 'which'
package 'ntpdate'
package 'fortune-mod'
package 'cowsay'

x509_certificate "#{node['fqdn']}" do
	ca node['x509']['ca']
	certificate node['base']['cert']['cert']
	key node['base']['cert']['key']
	bits 4096
	days 365
end

swap_file '/mnt/swap' do
	size node['base']['swap_size']
	persist true
end

%w(cowsay ps1).each do | file |
	template "/etc/profile.d/#{file}.sh" do
		source "#{file}.sh.erb"
	end
end
