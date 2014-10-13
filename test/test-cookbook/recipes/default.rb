consul_haproxy 'testing' do
  backends 'app_one' => 'release.app_one'
  frontends 'app_one' => '12345'
end

consul_haproxy 'app_two' do
  backends 'app_two' => 'preproduction.app_two'
  frontends 'app_two' => '54321'
end
