name 'email'
description 'Email server'
run_list(
		'recipe[base]',
		'recipe[iptables]',
		'recipe[mariadb]',
		'recipe[postfix]',
		'recipe[dovecot]',
		'recipe[opendkim]',
		'recipe[roundcube]',
)

default_attributes(
)
