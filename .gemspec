#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version = File.read('VERSION').chomp
  gem.date = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name = 'rdf-threadsafe'
  gem.homepage = 'http://github.com/rsinger/rdf-threadsafe'
  gem.license = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary = 'A hack to RDF.rb to override its autoloading feature to allow it to work in JRuby threads.'
  gem.description = 'A hack to RDF.rb to override its autoloading feature to allow it to work in JRuby threads.'

  gem.authors = ['Ross Singer']
  gem.email = 'rossfsinger@gmail.com'

  gem.platform = Gem::Platform::RUBY
  gem.files = %w(README VERSION) + Dir.glob('lib/**/*.rb')

  gem.require_paths = %w(lib)
  gem.extensions = %w()
  gem.test_files = %w()
  gem.has_rdoc = false

  gem.required_ruby_version = '>= 1.8.1'
  gem.requirements = []
  gem.add_runtime_dependency 'rdf', '= 0.3.3'
  gem.post_install_message = nil
end
