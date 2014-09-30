require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

SafeYAML::OPTIONS[:default_mode] = :safe

task :foodcritic
FoodCritic::Rake::LintTask.new do |t|
  t.options = { fail_tags: ['correctness'] }
  t.files = ['.']
end

RuboCop::RakeTask.new

desc 'Check cookbook syntax'
task :'syntax-check' do
  system('knife cookbook test -o .. consul-haproxy-cookbook')
end

desc 'Check cookbook style'
task lint: [:'syntax-check', :foodcritic, :rubocop]

desc 'Verify with test kitchen'
task 'integration-test' do
  config = Kitchen::Config.new
  config.instances.each do |instance|
    instance.test :always
  end
end
