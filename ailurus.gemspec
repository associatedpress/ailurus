# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ailurus/version"

Gem::Specification.new do |spec|
  spec.name          = "ailurus"
  spec.version       = Ailurus::VERSION
  spec.authors       = ["Justin Myers"]
  spec.email         = ["jmyers@ap.org"]

  spec.summary       = %q{Ruby client gem for PANDA servers}
  spec.description   = %q{Ruby client gem for newsroom data libraries running PANDA}
  spec.homepage      = "http://ctcinteract-svn01.ap.org/redmine/projects/ailurus"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://ctcinteract-svn01.ap.org/geminabox"
  end

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
