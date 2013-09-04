default['iptables']['open_ports'] << [25, 465]
default['postfix']['myhostname'] = 'mail.kroehling.de'
default['postfix']['smtpd_recipient_restrictions'] = 'permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination'
default['postfix']['virtual_mailbox_domains'] = 'mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf'
default['postfix']['virtual_mailbox_maps'] = 'mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf'
default['postfix']['virtual_alias_maps'] = 'mysql:/etc/postfix/mysql-virtual-alias-maps.cf'

# this enforces tls for sending/receiving emails, but some sites, like github, don't support sending emails
# via starttls... so, disable it if you want better compatibility, and enable it for improved security
default['postfix']['smtpd_tls_security_level'] = 'may' 
default['postfix']['smtp_tls_security_level'] = 'may' # change it to 'encrypt' to force STARTTLS among servers
