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

consul_haproxy_user = node['consul-haproxy']['user']
consul_haproxy_group = node['consul-haproxy']['group']

# Create consul-haproxy user
user 'consul-haproxy user' do
  not_if { consul_haproxy_user == 'root' }
  username consul_haproxy_user
  home '/dev/null'
  shell '/bin/false'
  comment 'consul-haproxy user'
end

# Create consul-haproxy group
group 'consul-haproxy group' do
  not_if { consul_haproxy_group == 'root' }
  group_name consul_haproxy_group
  members consul_haproxy_user
  append true
end

# Create consul-haproxy configuration directory
directory node['consul-haproxy']['config']['path'] do
  owner consul_haproxy_user
  group consul_haproxy_group
  mode '0755'
  recursive true
  action :create
end

# Create consul-haproxy log file
file '/var/log/consul-haproxy.log' do
  owner consul_haproxy_user
  group consul_haproxy_group
  mode '0644'
  action :create
end

# Create initial consul-haproxy configuration
config_location = File.join(
  node['consul-haproxy']['config']['path'],
  node['consul-haproxy']['config']['filename']
)

json_config = {
  'address' => node['consul-haproxy']['config']['agent_address'],
  'backends' => [],
  'paths' => [],
  'templates' => [],
  'reload_command' => (
    node['consul-haproxy']['haproxy']['reload_command'])
}.to_json
file config_location do
  owner consul_haproxy_user
  group consul_haproxy_group
  mode '0755'
  content json_config
  action :create_if_missing
end

command = File.join(node['consul-haproxy']['install_dir'], 'consul-haproxy')
config_file = File.join(
  node['consul-haproxy']['config']['path'],
  node['consul-haproxy']['config']['filename']
)

# Create a Consul-HAProxy init script
template '/etc/init.d/consul-haproxy' do
  source 'default_consul_haproxy_init.erb'
  mode '0755'
  variables(command: command, args: "-f #{config_file}")
end

service 'consul-haproxy' do
  supports status: true, restart: true
  action :enable
end

# Add global HAProxy configuration
global_config = File.join(
  node['consul-haproxy']['haproxy']['config_dir'],
  node['consul-haproxy']['haproxy']['global_config_filename']
)
template global_config do
  source 'global_haproxy_template.cfg.erb'
  mode '0644'
end
