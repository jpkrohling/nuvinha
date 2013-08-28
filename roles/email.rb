name 'email'
description 'Email server'
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
		'recipe[mailserver]',
		'recipe[postfix]',
		'recipe[dovecot]',
		'recipe[opendkim]',
		'recipe[roundcube]',
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
						:ssl => true,
						# :license => 'REPLACE_WITH_YOUR_KEY' ## set it before running the newrelic recipe
				},
				:application_monitoring => {
						:ssl => true,
						# :license => 'REPLACE_WITH_YOUR_KEY' ## set it before running the newrelic recipe
				}
		},
)
