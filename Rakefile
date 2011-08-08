#!/usr/bin/env ruby
#$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rake'

require "rspec/core/rake_task"



desc "Run all specs"

RSpec::Core::RakeTask.new(:specs) do |spec|
  spec.pattern = 'specs/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end

desc "Build the rdf-threadsafe-#{File.read('VERSION').chomp}.gem file"
task :build do
  sh "gem build .gemspec"
end