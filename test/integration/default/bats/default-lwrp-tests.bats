@test "should drop init script" {
    test -f "/etc/init.d/consul-haproxy"
}

@test "should start HAProxy with all config files" {
    pgrep -f "/usr/local/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -D -f /etc/haproxy/haproxy.d/app_two.cfg -f /etc/haproxy/haproxy.d/testing.cfg"
}

@test "should have HAProxy admin listening" {
    wget localhost:10097 -qS -O- 2>&1 | grep -q "200 OK"
}

@test "should run consul-haproxy daemon" {
    pgrep "consul-haproxy"
}

@test "should create first app's HAProxy config" {
    test -f "/etc/haproxy/haproxy.d/testing.cfg"
}

@test "should add app one's backend" {
    grep "backend app_one" "/etc/haproxy/haproxy.d/testing.cfg"
}

@test "should add app one's frontend" {
    grep "frontend app_one" "/etc/haproxy/haproxy.d/testing.cfg"
}

@test "should add app one's backend port" {
    grep "12345" "/etc/haproxy/haproxy.d/testing.cfg"
}

@test "should create second app's HAProxy config" {
    test -f "/etc/haproxy/haproxy.d/app_two.cfg"
}

@test "should add app two's backend" {
    grep "backend app_two" "/etc/haproxy/haproxy.d/app_two.cfg"
}

@test "should add app two's frontend" {
    grep "frontend app_two" "/etc/haproxy/haproxy.d/app_two.cfg"
}

@test "should add app two's backend port" {
    grep "54321" "/etc/haproxy/haproxy.d/app_two.cfg"
}

@test "should not have global settings in app specific config" {
    ! grep "global" "/etc/haproxy/haproxy.d/testing.cfg"
}

@test "should not have default settings in app specific config" {
    ! grep "defaults" "/etc/haproxy/haproxy.d/testing.cfg"
}

@test "should not have admin settings in app specific config" {
    ! grep "listen admin" "/etc/haproxy/haproxy.d/testing.cfg"
}
