# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gtmtech/crypto'

Gem::Specification.new do |gem|
  gem.name          = "gtmtech-crypto"
  gem.version       = Gtmtech::Crypto::VERSION
  gem.description   = "Simple tool for accounting of cryptocurrencies"
  gem.summary       = "Simple tool for accounting of cryptocurrencies"
  gem.author        = "Geoff Meakin"
  gem.license       = "MIT"

  gem.homepage      = "http://github.com/gtmtechltd/crypto"
  gem.files         = `git ls-files`.split($/).reject { |file| file =~ /^features.*$/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
