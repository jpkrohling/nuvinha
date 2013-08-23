name 'email'
description 'Email server'
run_list(
		'recipe[hostname]',
		'recipe[build-essential]',
		'recipe[x509]',
		'recipe[base]',
		'recipe[mariadb]',
		'recipe[iptables]',
		'recipe[mailserver]',
		'recipe[postfix]',
		'recipe[dovecot]',
		'recipe[opendkim]',
		'recipe[apache]',
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
		}
)
