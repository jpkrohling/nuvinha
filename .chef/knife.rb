current_dir = File.dirname(__FILE__)
user = 'jpk-cupuassu' #ENV['OPSCODE_USER'] || ENV['USER']

log_level                :info
log_location             STDOUT

node_name                user
client_key               "#{ENV['HOME']}/.chef/jpk-cupuassu.pem"
validation_client_name   "cupuassu-validator"
validation_key           "#{ENV['HOME']}/.chef/cupuassu-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/cupuassu"

cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

cookbook_copyright 'kroehling.de'
cookbook_email 'ops@kroehling.de'
cookbook_license 'apachev2'

knife[:region] = ENV['OPSCODE_AWS_REGION']
knife[:aws_ssh_key_id] = ENV['OPSCODE_AWS_SSH_KEY']
knife[:aws_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']