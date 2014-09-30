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

backends = []
node['consul-haproxy']['config']['backends'].each do |name, spec|
  backends << "#{name}=#{spec}"
end

path = (node['consul-haproxy']['config']['haproxy_config_dir'] +
        node['consul-haproxy']['config']['haproxy_config_filename'])

# Create and write out the configuration for consul-haproxy
json_config = {
  'address' => node['consul-haproxy']['config']['agent_address'],
  'backends' => backends,
  'path' => path,
  'template' => node['consul-haproxy']['config']['haproxy_template'],
  'reload_command' => (
    node['consul-haproxy']['config']['haproxy_reload_command'])
}.to_json

file File.join(node['consul-haproxy']['config']['path'],
               node['consul-haproxy']['config']['filename']) do
  owner consul_haproxy_user
  group consul_haproxy_group
  mode '0755'
  content json_config
  action :create
end

template_vars = {
  'backends' => node['consul-haproxy']['config']['backends'],
  'frontends' => node['consul-haproxy']['config']['frontends'],
  'extras' => node['consul-haproxy']['extra_template_vars']
}

# Render the HAProxy template template (so now it's a GO template)
template node['consul-haproxy']['config']['haproxy_template'] do
  mode '0755'
  source node['consul-haproxy']['template']
  owner consul_haproxy_user
  group consul_haproxy_group
  cookbook node['consul-haproxy']['template_cookbook'] \
    unless node['consul-haproxy']['template_cookbook'].nil?
  variables template_vars
end
