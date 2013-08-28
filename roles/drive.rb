name 'drive'
description 'Cloud drive server'
run_list(
		'recipe[hostname]',
		'recipe[build-essential]',
		'recipe[openssl]',
		'recipe[x509]',
		'recipe[chef-client]',
		'recipe[base]',
		'recipe[mariadb]',
		'recipe[iptables]',
		'recipe[apache]',
		'recipe[php]',
		'recipe[owncloud]',
)

default_attributes(
		:set_fqdn => '*.kroehling.de',
		:x509 => {
				:ca => 'kroehling.de',
				:country => 'DE',
				:state => 'Bayern',
				:city => 'Muenchen',
				:organization => 'kroehling.de',
				:email => 'ops@kroehling.de'
		},
		:build_essential => {
				:compiletime => true
		},
		:newrelic => {
				:server_monitoring => {
						:ssl => true
						# :license => 'REPLACE_WITH_YOUR_KEY' ## set it directly on chef server
				},
				:application_monitoring => {
						:ssl => true
						# :license => 'REPLACE_WITH_YOUR_KEY' ## set it directly on chef server
				}
		},
)
