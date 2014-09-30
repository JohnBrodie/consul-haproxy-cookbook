@test "should drop init script" {
    test -f "/etc/init.d/consul-haproxy"
}

@test "should run consul-haproxy daemon" {
    pgrep "consul-haproxy"
}

@test "should create HAProxy config" {
    test -f "/etc/haproxy/haproxy.cfg"
}

@test "should add app backend" {
    grep "app" "/etc/haproxy/haproxy.cfg"
}

@test "should add app backend port" {
    grep "12345" "/etc/haproxy/haproxy.cfg"
}
