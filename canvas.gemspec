Gem::Specification.new do |s|
  s.name        = 'easol-canvas'
  s.version     = '0.1.0'
  s.summary     = "CLI to help with building themes for Easol"
  s.description = <<~EOF
    Canvas is a command line tool to help with building themes for Easol.
    It provides tooling to check theme directories for errors and to make sure
    they confirm with the Easol theme spec.
  EOF
  s.authors     = ["Kyle Byrne"]
  s.email       = "kyle@easol.com"
  s.files       = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.license     = 'MIT'

  s.add_dependency "thor"
end
