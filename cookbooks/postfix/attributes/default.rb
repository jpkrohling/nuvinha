default['postfix']['myhostname'] = 'mail.kroehling.de'
default['postfix']['smtpd_recipient_restrictions'] = 'permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination'
default['postfix']['virtual_mailbox_domains'] = 'mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf'
default['postfix']['virtual_mailbox_maps'] = 'mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf'
default['postfix']['virtual_alias_maps'] = 'mysql:/etc/postfix/mysql-virtual-alias-maps.cf'

