#
# Copyright 2014 John Brodie <john@brodie.me>
# Copyright 2014 AWeber Communications, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Git reference to download. Can be a commit hash, HEAD, tag, etc.
# The default here is the commit merging multi-config support into master
default['consul-haproxy']['source_reference'] = (
  '21664b79e24089b90956b832438b54231aed1db4')

# Directory to drop symlink to executable.
default['consul-haproxy']['install_dir'] = '/usr/local/bin'

# The user/group to run haproxy-consul as.
default['consul-haproxy']['user'] = 'consulhaproxy'
default['consul-haproxy']['group'] = 'consulhaproxy'

# Path to consul-haproxy config file.
default['consul-haproxy']['config']['path'] = '/etc/consul-haproxy'

# Name of config file.
default['consul-haproxy']['config']['filename'] = 'consul-haproxy.json'

# Address of the Consul agent.
default['consul-haproxy']['config']['agent_address'] = '127.0.0.1:8500'

## HAProxy Configuration ##

# The user/group of HAProxy itself. Used when writing the rendered
# HAProxy config file.
default['consul-haproxy']['haproxy']['user'] = (
  default['haproxy']['user'].nil? ? 'root' : node['haproxy']['user'])
default['consul-haproxy']['haproxy']['group'] = (
  default['haproxy']['group'].nil? ? 'root' : node['haproxy']['group'])

# Command used to reload HAProxy
default['consul-haproxy']['haproxy']['reload_command'] = (
  '/etc/init.d/haproxy reload')

# HAProxy config dir (where rendered template will be written)
# Must be writable by consul-haproxy user, and readable by HAProxy
default['consul-haproxy']['haproxy']['config_dir'] = '/etc/haproxy'

# Make the haproxy cookbook agree with us
override['haproxy']['conf_dir'] = (
  node['consul-haproxy']['haproxy']['config_dir'])

# Directory for LWRP-derived "extra" HAProxy templates
default['consul-haproxy']['haproxy']['extra_config_dir'] = 'haproxy.d'

# HAProxy global configuration filename
default['consul-haproxy']['haproxy']['global_config_filename'] = 'haproxy.cfg'

# HAProxy Global Configuration
# Each section of the global configuration gets it's own Hash, set whatever
# options you wish in each section as {option_name => value}
default['consul-haproxy']['haproxy']['global'] = {
  'log' => '/dev/log local5',
  'maxconn' => '4096',
  'user' => node['consul-haproxy']['haproxy']['user'],
  'group' => node['consul-haproxy']['haproxy']['group'],
  'stats' => 'socket /var/run/haproxy_stat.sock user '\
    'root group root mode 700 level admin'
}

default['consul-haproxy']['haproxy']['defaults'] = {
  'clitimeout' => '50000',
  'contimeout' => '5000',
  'log' => 'global',
  'maxconn' => '2000',
  'retries' => '3',
  'srvtimeout' => '50000'
}

# If an admin port is defined, we will configure HAProxy's admin interface
# to listen on it
default['consul-haproxy']['haproxy']['admin']['port'] = '10097'
