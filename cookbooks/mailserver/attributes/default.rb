default['mailserver']['recipient_delimiter'] = '.'
default['mailserver']['ssl_cipher_list'] = 'ECDHE-RSA-AES128-SHA256:AES128-GCM-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH'
default['mailserver']['database']['user'] = 'mailuser'
#default['mailserver']['database']['password'] = set it on the recipe, with a random value
default['mailserver']['database']['hosts'] = '127.0.0.1'
default['mailserver']['database']['dbname'] = 'mailserver'
