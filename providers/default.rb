use_inline_resources if defined? use_inline_resources # Chef 11+

def whyrun_supported?
  true
end

action :create do
  name = @new_resource.name
  template_cookbook = @new_resource.template_cookbook
  haproxy_template = @new_resource.haproxy_template
  frontends = @new_resource.frontends
  backends = @new_resource.backends
  extra_template_vars = @new_resource.extra_template_vars

  haproxy_config_file = ::File.join(
    node['consul-haproxy']['config']['path'],
    node['consul-haproxy']['config']['filename']
  )
  haproxy_config_path = ::File.join(
    node['consul-haproxy']['haproxy']['config_dir'],
    node['consul-haproxy']['haproxy']['extra_config_dir']
  )
  path = ::File.join(haproxy_config_path, name)
  path = path.concat('.cfg')
  template_location = ::File.join(
    node['consul-haproxy']['config']['path'], name)

  # Make sure the HAProxy config directory exists
  create_haproxy_config_dir(haproxy_config_path)

  # Render the HAProxy template template (so now it's a GO template)
  create_consul_haproxy_template(
    template_location,
    haproxy_template,
    template_cookbook,
    backends,
    frontends,
    extra_template_vars
  )

  update_json_config(haproxy_config_file, backends, path, template_location)

  render_defaults
  restart_service
end

# Add defaults file that we can add our LWRP-derived config files to
def render_defaults
  template '/etc/default/haproxy' do
    cookbook 'consul-haproxy'
    source 'haproxy_defaults.erb'
    mode '0644'
    action :create
  end
end

# Restart the consul-haproxy service. It currently does not appreciate an
# attempted reload.
def restart_service
  service 'consul-haproxy' do
    action :restart
  end
end

def create_haproxy_config_dir(config_dir)
  directory config_dir do
    owner node['consul-haproxy']['haproxy']['user']
    group node['consul-haproxy']['haproxy']['group']
    mode '0755'
    recursive true
  end
end

# Render the given Chef template.  This will result in writing out
# a Consul-HAProxy template in the GO templating language, which
# Consul-HAProxy will use directly.
def create_consul_haproxy_template(
    location, source, cookbook, backends, frontends, extra_vars)
  template location do
    mode '0755'
    source source
    owner node['consul-haproxy']['user']
    group node['consul-haproxy']['group']
    cookbook cookbook
    variables(backends: backends, frontends: frontends, extras: extra_vars)
  end
end

# Return a list of backends as a string in the format Consul-HAProxy
# expects in it's configuration.
def stringify_backends(backends)
  backend_strings = []
  backends.each do |name, spec|
    backend_strings << "#{name}=#{spec}"
  end
  backend_strings
end

# Add the new backend, path, and template to the Consul-HAProxy
# configuration file.
def update_json_config(haproxy_config_file, backends, path, template)
  json_config = ::JSON.parse(IO.read(haproxy_config_file))
  json_config['backends'] = (
    json_config['backends'] | stringify_backends(backends))
  json_config['paths'] = json_config['paths'] | [path]
  json_config['templates'] = json_config['templates'] | [template]
  write_json_config(haproxy_config_file, json_config)
end

def write_json_config(haproxy_config_file, json_config)
  file haproxy_config_file do
    action :create
    owner node['consul-haproxy']['user']
    group node['consul-haproxy']['group']
    mode '0755'
    content json_config.to_json
  end
end
