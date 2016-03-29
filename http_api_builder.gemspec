# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_api_builder/version'

Gem::Specification.new do |spec|
  spec.name          = 'http_api_builder'
  spec.version       = HttpApiBuilder::VERSION
  spec.authors       = ['Jeff Sandberg']
  spec.email         = ['paradox460@gmail.com']

  spec.summary       = 'A utility gem providing a DSL for building HTTP api wrappers.'
  spec.description   = 'A gem providing a nice DSL for building HTTP api wrappers.'
  spec.homepage      = 'https://github.com/paradox460/http_api_builder'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = ">= 2.2"

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'http'
end
