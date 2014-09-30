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

# Make sure the HAProxy config directory exists
directory node['consul-haproxy']['config']['haproxy_config_dir'] do
  owner node['consul-haproxy']['haproxy_user']
  group node['consul-haproxy']['haproxy_group']
  mode '0755'
  recursive true
  action :create
end

command = File.join(node['consul-haproxy']['install_dir'], 'consul-haproxy')
config_file = File.join(node['consul-haproxy']['config']['path'],
                        node['consul-haproxy']['config']['filename'])

template '/etc/init.d/consul-haproxy' do
  source 'default_consul_haproxy_init.erb'
  mode '0755'
  variables(command: command, args: "-f #{config_file}")
  notifies :restart, 'service[consul]', :immediately
end

service 'consul-haproxy' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
  subscribes :restart, "file[#{config_file}", :delayed
end
