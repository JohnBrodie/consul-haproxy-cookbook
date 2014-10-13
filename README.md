consul-haproxy-cookbook
=======================
Builds, installs, configures, and runs [Consul-HAProxy][1], the
glue between [Consul][2] and [HAProxy][3] that rewrites HAProxy config
when there are service discovery changes.

## Supported Platforms

- Ubuntu 12.04, 14.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['source_reference']</tt></td>
    <td>String</td>
    <td>Version to install, any git identifier will do</td>
    <td><tt>tags/v0.1.0</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['install_dir']</tt></td>
    <td>String</td>
    <td>Location to install Consul-HAProxy</td>
    <td><tt>/usr/local/bin</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['user']</tt></td>
    <td>String</td>
    <td>User whom will run the consul-haproxy service</td>
    <td><tt>consulhaproxy</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['group']</tt></td>
    <td>String</td>
    <td>Group the consul-haproxy user will belong to</td>
    <td><tt>consulhaproxy</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['config']['path']</tt></td>
    <td>String</td>
    <td>consul-haproxy config dir path</td>
    <td><tt>/etc/consul-haproxy</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['config']['filename']</tt></td>
    <td>String</td>
    <td>consul-haproxy config file name</td>
    <td><tt>consul-haproxy.json</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['config']['agent_address']</tt></td>
    <td>String</td>
    <td>IP and port of the consul agent</td>
    <td><tt>127.0.0.1:8500</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['user']</tt></td>
    <td>String</td>
    <td>User running HAProxy, used when writing the rendered HAProxy config</td>
    <td><tt>node['haproxy']['user']</tt></td>
  </tr>
    <tr>
    <td><tt>['consul-haproxy'][haproxy']['group]</tt></td>
    <td>String</td>
    <td>Group of user running HAProxy, used when writing the rendered HAProxy config</td>
    <td><tt>node['haproxy']['group']</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['reload_command']</tt></td>
    <td>String</td>
    <td>Command to reload HAProxy's configuration</td>
    <td><tt>/etc/init.d/haproxy reload</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['config_dir']</tt></td>
    <td>String</td>
    <td>Path of HAProxy config dir</td>
    <td><tt>/etc/haproxy</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['extra_config_dir']</tt></td>
    <td>String</td>
    <td>Directory to store cookbook-specific HAProxy configs we'll create</td>
    <td><tt>haproxy.d</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['global_config_filename']</tt></td>
    <td>String</td>
    <td>Name of main HAProxy config file</td>
    <td><tt>haproxy.cfg</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['global']</tt></td>
    <td>Hash</td>
    <td>Any settings to put in the "global" section of the HAProxy config, as key => value pairs</td>
    <td><tt>See cookbook</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['defaults']</tt></td>
    <td>Hash</td>
    <td>Any settings to put in the "defaults" section of the HAProxy config, as key => value pairs</td>
    <td><tt>See cookbook</tt></td>
  </tr>
  <tr>
    <td><tt>['consul-haproxy']['haproxy']['admin']['port']</tt></td>
    <td>String</td>
    <td>If an admin port is defined, configure HAProxy's admin interface to listen on it</td>
    <td><tt>10097</tt></td>
  </tr>
</table>

## Usage

### consul-haproxy::default

Install Consul-HAProxy from source, configure it as specified via the cookbook
attributes, and start it up.  An init script is dropped as `/etc/init.d/consul-haproxy`
that can be used to start, stop, restart, and reload the service.

`node['consul-haproxy']['config']['backends']` must be set for `Consul-HAProxy` to
successfully start.


### consul-haproxy::install_source

Download, build, and install `Consul-HAProxy` from source.

Include `consul-haproxy::install_source` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[consul-haproxy::install_source]"
  ]
}
```

### consul-haproxy::configure_service

Create user and group for `Consul-HAProxy`, the global configuration file, and a
Debian init script.


Include `consul-haproxy::configure_service` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[consul-haproxy::configure_service]"
  ]
}
```

## Providers

# consul_haproxy

The `consul_haproxy` LWRP configures `consul-haproxy` to create and update one HAProxy configuration file.  This configuration file is maintained separate from others, allowing for multiple cookbooks to make use of `Consul-HAProxy`.  At run time, HAProxy will combine these individual configurations, along with the global configuration dropped by `consul-haproxy::configure_service`, and properly route requests.

### Actions

 * `create` - Create a `Consul-HAProxy` configuration template using the specified information

### Attribute Parameters

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>name</tt></td>
    <td>String</td>
    <td>Name of the service we are creating a configuration file for</td>
    <td><tt>`Nil`</tt></td>
  </tr>
  <tr>
    <td><tt>haproxy_template</tt></td>
    <td>String</td>
    <td>Filename of the HAProxy template to use. Must exist in the `template_cookbook`</td>
    <td><tt>default_haproxy_template.cfg.erb</tt></td>
  </tr>
  <tr>
    <td><tt>template_cookbook</tt></td>
    <td>String</td>
    <td>Name of the cookbook the specified `haproxy_template` resides in</td>
    <td><tt>consul-haproxy</tt></td>
  </tr>
  <tr>
    <td><tt>extra_template_vars</tt></td>
    <td>Hash</td>
    <td>Arbitrary variables to pass to the HAProxy template</td>
    <td><tt>`{}`</tt></td>
  </tr>
  <tr>
    <td><tt>backends</tt></td>
    <td>Hash</td>
    <td>A list of `consul-haproxy` backend specifications. Follow the form `{name: tag.service@datacenter:port}`</td>
    <td><tt>`{}`</tt></td>
  </tr>
  <tr>
    <td><tt>frontends</tt></td>
    <td>Hash</td>
    <td>A list of `HAProxy` frontends.  Follow the form `{name: port}`. Name must match backend</td>
    <td><tt>`{}`</tt></td>
  </tr>
</table>

## Authors

Created at [AWeber Communications][4] by John Brodie

[1]: https://github.com/hashicorp/consul-haproxy
[2]: http://consul.io
[3]: http://www.haproxy.org
[4]: http://www.aweber.com
