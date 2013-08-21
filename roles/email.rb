name 'email'
description 'Email server'
run_list(
		'recipe[build-essential]',
		'recipe[base]',
		'recipe[mariadb]',
		'recipe[iptables]',
		'recipe[mailserver]',
		'recipe[postfix]',
		'recipe[dovecot]',
		'recipe[opendkim]',
		'recipe[roundcube]',
)

default_attributes(
		:build_essential => {
				:compiletime => true
		}
)
