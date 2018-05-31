# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_store/version'

Gem::Specification.new do |spec|
  spec.name          = 'multi_store'
  spec.version       = MultiStore::VERSION
  spec.authors       = ['Matt Wilde']
  spec.email         = ['matt@gusto.com']

  spec.summary       = %q{An ActiveSupport::Store that delegates to a series of stores in order.}
  spec.homepage      = 'https://github.com/Gusto/multi_store'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '>= 3', '< 6'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'redis-activesupport'
end
