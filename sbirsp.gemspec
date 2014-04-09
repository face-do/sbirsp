# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sbirsp/version'

Gem::Specification.new do |spec|
  spec.name          = "Sbirsp"
  spec.version       = Sbirsp::VERSION
  spec.authors       = ["face-do"]
  spec.email         = ["face-do@users.noreply.github.com"]
  spec.summary       = %q{Get RealTime Stock Price from SBIsec. }
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "masque"
end
