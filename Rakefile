require "bundler/gem_tasks"
require 'rake/testtask'

require 'bundler'
Bundler.setup

Rake::TestTask.new do |t|
  t.libs << "."
  t.libs << 'test'
  t.pattern = "test/**/*_test.rb"
end

task :default => :test
