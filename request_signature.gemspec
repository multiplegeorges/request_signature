
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "request_signature"

Gem::Specification.new do |spec|
  spec.name          = "request_signature"
  spec.version       = RequestSignature::VERSION
  spec.authors       = ["Georges Gabereau"]
  spec.email         = ["georges@hellocharlie.io"]

  spec.summary       = %q{A gem that signs API requests and verifies received requests.}
  spec.description   = %q{A gem that uniquely signs API requests so that a receiver can be sure they came from you.
                          It can also verify signed requests, assuming they were signed in the same way.}
  spec.homepage      = "https://github.com/multiplegeorges/request_signature"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
