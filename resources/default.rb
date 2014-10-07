actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :template, :kind_of => String, :default => 'default_haproxy_template.cfg.erb'
attribute :template_cookbook, :kind_of => String
attribute :haproxy_template_location, :kind_of => String, :required => true
attribute :haproxy_config_dir, :kind_of => String, :default => '/etc/haproxy/'
attribute :haproxy_config_filename, :kind_of => String, :default => 'haproxy.cfg'
attribute :extra_template_vars, :kind_of => Hash, :default => {}
attribute :backends, :kind_of => Hash, :default => {}
attribute :frontends, :kind_of => Hash, :default => {}
