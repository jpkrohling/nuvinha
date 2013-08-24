#
# Cookbook Name:: openssl
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

%w(openssl-1.0.1e-5.fc19.x86_64.rpm openssl-libs-1.0.1e-5.fc19.x86_64.rpm openssl-devel-1.0.1e-5.fc19.x86_64.rpm).each do | file |
	cookbook_file file do
		backup false
		path "/tmp/#{file}"
		action :create_if_missing
	end
end

# dirty hack, as both needs to be installed at the same time, otherwise, we could just install via the package
# resource.
execute 'yum install -y /tmp/openssl*.rpm' do
	not_if 'test $(rpm -q openssl) = "openssl-1.0.1e-5.fc19.x86_64"'
end