# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'habitable/version'

Gem::Specification.new do |spec|
  spec.name          = "habitable"
  spec.version       = Habitable::VERSION
  spec.authors       = ["AdamBuchan"]
  spec.email         = ["adam.buchan@gmail.com"]
  spec.description   = %q{Provides a quality-of-life index score for UK locations}
  spec.summary       = %q{Quality Of Life index}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "json"
  spec.add_dependency "geocoder"
  spec.add_dependency "httparty"

  spec.add_dependency "nestoria"
  spec.add_dependency "OpenWeather"
  
end
