actions :create
default_action :create

attribute :name, kind_of: String, name_attribute: true
attribute :haproxy_template,
          kind_of: String,
          default: 'default_haproxy_template.cfg.erb'
attribute :template_cookbook, kind_of: String, default: 'consul-haproxy'
attribute :extra_template_vars, kind_of: Hash, default: {}
attribute :backends, kind_of: Hash, default: {}
attribute :frontends, kind_of: Hash, default: {}
