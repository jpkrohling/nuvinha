#
# Cookbook Name:: mariadb
# Recipe:: storage
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

include_recipe 'aws'

aws = data_bag_item('aws', 'main')
aws_ebs_volume 'mariadb-data' do
	aws_access_key aws['aws_access_key_id']
	aws_secret_access_key aws['aws_secret_access_key']
	size node['mariadb']['storage_size']
	device '/dev/xvdk'
	action [ :create, :attach ]
end

bash 'create_filesystem' do
	user 'root'
	code <<-EOH
    parted /dev/xvdk mklabel gpt
    parted /dev/xvdk mkpart logical ext4 1 -1 -- "-1"
    parted /dev/xvdk set 1 lvm on
    yes | parted /dev/xvdk mkpart logical ext4 1 -- "-1"
    mkfs.ext4 /dev/xvdk1
	EOH
	not_if 'parted /dev/xvdk print | grep ext4'
end

mount '/var/lib/mysql' do
	device '/dev/xvdk1'
	options 'rw noatime'
	fstype 'ext4'
	action [ :enable, :mount ]
	not_if 'cat /proc/mounts | grep /var/lib/mysql'
end

directory '/var/lib/mysql' do
	owner 'mysql'
	group 'mysql'
	mode '0750'
	recursive true
end
