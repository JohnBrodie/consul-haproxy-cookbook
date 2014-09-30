name 'consul-haproxy'
maintainer 'John Brodie'
maintainer_email 'john@brodie.me'
license 'Apache v2.0'
description 'Installs/Configures consul-haproxy'
long_description 'Installs/Configures consul-haproxy'
version '0.1.0'

recipe 'consul-haproxy', 'Installs and starts consul-haproxy daemon.'

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'

depends 'consul'
depends 'golang'
