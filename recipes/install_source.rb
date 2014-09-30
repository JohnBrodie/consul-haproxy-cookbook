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
directory File.join(node['go']['gopath'], 'src/github.com/hashicorp') do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

git File.join(
    node['go']['gopath'], '/src/github.com/hashicorp/consul-haproxy') do
  repository 'https://github.com/hashicorp/consul-haproxy.git'
  reference node['consul-haproxy']['source_reference']
  action :sync
end

golang_package 'github.com/hashicorp/consul-haproxy' do
  action :install
end

link File.join(node['consul-haproxy']['install_dir'], 'consul-haproxy') do
  to File.join(node['go']['gobin'], 'consul-haproxy')
end
