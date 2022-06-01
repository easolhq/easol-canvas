# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "easol-canvas"
  s.version     = "1.1.0"
  s.summary     = "CLI to help with building themes for Easol"
  s.description = <<~EOF
    Canvas is a command line tool to help with building themes for Easol.
    It provides tooling to check theme directories for errors and to make sure
    they confirm with the Easol theme spec.
  EOF
  s.authors     = ["Kyle Byrne", "Ian Mooney"]
  s.email       = "developers@easol.com"
  s.files       = Dir["lib/**/*.rb"] + Dir["bin/*"]
  s.homepage    = "https://rubygems.org/gems/easol-canvas"
  s.license     = "MIT"

  s.executables << "canvas"

  s.add_dependency "thor", "~> 1.2"
  s.add_dependency "nokogiri", "~> 1.13"
  s.add_dependency "cli-ui", "~> 1.5"
  s.add_dependency "liquid", "~> 5.3"
end
