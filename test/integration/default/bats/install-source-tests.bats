@test "should create source directory" {
    test -d /opt/go/src/github.com/hashicorp
}

@test "should checkout source from git" {
    test -d /opt/go/src/github.com/hashicorp/consul-haproxy
}

@test "should build consul-haproxy binary" {
    test -f /opt/go/bin/consul-haproxy
}

@test "should symlink to install directory" {
    test -h /usr/local/bin/consul-haproxy
}
