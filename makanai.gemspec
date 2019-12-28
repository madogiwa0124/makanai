lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "makanai/version"

Gem::Specification.new do |spec|
  spec.name          = "makanai"
  spec.version       = Makanai::VERSION
  spec.authors       = ["Madogiwa"]
  spec.email         = ["madogiwa0124@gmail.com"]

  spec.summary       = %q{simple web application framework for learning.}
  spec.description   = %q{simple web application framework for learning.}
  spec.homepage      = "https://github.com/Madogiwa0124/makanai"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Madogiwa0124/makanai"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", ">= 10", "< 14"
  spec.add_dependency "rack", "~> 2.0.7"
  spec.add_dependency "sqlite3", "~> 1.4.1"
  spec.add_development_dependency "rubocop", "~> 0.74"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
