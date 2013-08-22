name             'mailserver'
maintainer       'kroehling.de'
maintainer_email 'ops@kroehling.de'
license          'Apache 2.0'
description      'Installs/Configures mailserver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'openssl'
depends 'x509'