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

# The user/group of HAProxy itself. Used when writing the rendered
# HAProxy config file.
default['consul-haproxy']['haproxy_user'] = 'root'
default['consul-haproxy']['haproxy_group'] = 'root'

# Cookbook containing the HAProxy template. If not set, the
# template contained in the `consul-haproxy` cookbook will be used.
default['consul-haproxy']['template_cookbook'] = nil

# The name of the template to use for the
# HAProxy template (an .erb Chef template)
default['consul-haproxy']['template'] = 'default_haproxy_template.cfg.erb'

## Consul-HAProxy Daemon configuration ##
# Path to consul-haproxy config file.
default['consul-haproxy']['config']['path'] = '/etc/consul-haproxy'

# Name of config file.
default['consul-haproxy']['config']['filename'] = 'consul-haproxy.json'

# Address of the Consul agent.
default['consul-haproxy']['config']['agent_address'] = '127.0.0.1:8500'

# Location to store the HAProxy (unrendered) template
default['consul-haproxy']['config']['haproxy_template'] = (
    '/etc/consul-haproxy/haproxy_template.cfg')

# HAProxy config file location (where rendered template will be written)
# Must be writable by consul-haproxy user, and readable by HAProxy
default['consul-haproxy']['config']['haproxy_config_dir'] = '/etc/haproxy/'
default['consul-haproxy']['config']['haproxy_config_filename'] = 'haproxy.cfg'

# Command used to reload HAProxy
default['consul-haproxy']['config']['haproxy_reload_command'] = (
    '/etc/init.d/haproxy reload')

# A hash of backends.  Keys are the name of the backend, values are
# the associated backend specification.  Ex: {'app' => 'release.webapp'}
default['consul-haproxy']['config']['backends'] = {}

# A hash of frontends you wish to expose via HAProxy.  Names _must_ match
# the backend specification.  The keys in the hash are frontend names,
# the values are the port to expose the service on.  Ex: {'app' => '11111'}
default['consul-haproxy']['config']['frontends'] = {}

# Any extra variables you wish to pass into your HAProxy template.
default['consul-haproxy']['extra_template_vars'] = {}
