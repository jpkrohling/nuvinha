default['base']['ssl_cipher_list'] = 'EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS'
default['base']['cert']['cert'] = "/etc/pki/tls/certs/#{node['fqdn']}.pem"
default['base']['cert']['key'] = "/etc/pki/tls/private/#{node['fqdn']}.pem"
