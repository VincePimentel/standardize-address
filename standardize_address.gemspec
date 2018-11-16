require_relative "./lib/standardize_address/version"

Gem::Specification.new do |spec|
  spec.name          = "standardize-address"
  spec.version       = StandardizeAddress::VERSION
  spec.authors       = ["Vince Andrew Pimentel"]
  spec.email         = ["contact@vincep.me"]

  spec.summary       = "Utility to standardize any given address."
  spec.description   = "Utility to standardize/verify an address. Corrects errors in street addresses, including abbreviations and missing information and supplies ZIP Codes and ZIP Codes + 4"
  spec.homepage      = "https://rubygems.org/gems/standardize-address"
  spec.license       = "MIT"
  spec.executables << "start"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "pry"
end
