# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cielo/version'

Gem::Specification.new do |gem|
  gem.name          = "cielorb"
  gem.version       = Cielo::VERSION
  gem.authors       = ["Rafael Felix"]
  gem.email         = ["felix.rafael@gmail.com"]
  gem.description   = %q{Gem to communicates with cielo gateway}
  gem.summary       = %q{Gem to communicates with cielo gateway}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency "builder", "~> 2.0"
  gem.add_development_dependency "minitest", "~> 4.5.0"
  gem.add_development_dependency "turn", "~> 0.9.6"
end
