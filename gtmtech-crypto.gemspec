# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "gtmtech-crypto"
  gem.version       = "0.0.6"
  gem.description   = "Simple tool for accounting of cryptocurrencies"
  gem.summary       = "Simple tool for accounting of cryptocurrencies"
  gem.author        = "Geoff Meakin"
  gem.license       = "MIT"

  gem.homepage      = "http://github.com/gtmtechltd/crypto"
  gem.files         = `git ls-files`.split($/).reject { |file| file =~ /^features.*$/ }
  gem.executables   << "crypto"
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency('trollop', '~> 2.0')
end
