@test "should create configuration directory" {
    test -d "/etc/consul-haproxy"
}

@test "should create JSON configuration file" {
    test -f "/etc/consul-haproxy/consul-haproxy.json"
}

@test "should create app one's HAProxy-Consul template" {
    test -f "/etc/consul-haproxy/testing"
}

@test "should create app two's HAProxy-Consul template" {
    test -f "/etc/consul-haproxy/app_two"
}

@test "should not have global settings in app specific config" {
    grep "global" "/etc/haproxy/haproxy.cfg"
}

@test "should not have default settings in app specific config" {
    grep "defaults" "/etc/haproxy/haproxy.cfg"
}

@test "should not have admin settings in app specific config" {
    grep "listen admin" "/etc/haproxy/haproxy.cfg"
}
