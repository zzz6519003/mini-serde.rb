Gem::Specification.new do |spec|
  spec.name          = "mini-serde"
  spec.version       = "0.1.0"
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]
  spec.summary       = "A minimal JSON serialization library for Ruby"
  spec.description   = "Mini-serde is a simple JSON serialization and deserialization library inspired by Rust's mini-serde."
  spec.homepage      = "https://github.com/yourusername/mini-serde.rb"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
end