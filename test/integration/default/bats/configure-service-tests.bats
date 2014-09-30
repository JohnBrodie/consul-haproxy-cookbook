@test "should create configuration directory" {
    test -d "/etc/consul-haproxy"
}

@test "should create JSON configuration file" {
    test -f "/etc/consul-haproxy/consul-haproxy.json"
}

@test "should create HAProxy-Consul template" {
    test -f "/etc/consul-haproxy/haproxy_template.cfg"
}
