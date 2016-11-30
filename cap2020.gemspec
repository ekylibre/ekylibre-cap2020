$:.push File.expand_path("../lib", __FILE__)

require "cap2020/version"

Gem::Specification.new do |s|
  s.name        = 'cap2020'
  s.version     = Cap2020::VERSION
  s.authors     = ["Jérémie Bonal", "Alexandre Lécuelle"]
  s.email       = ["jbonal@ekylibre.com", "alecuelle@ekylibre.com"]
  s.homepage    = "https://forge.ekylibre.com/projects/cap-trap/repository"
  s.summary     = "[IOT] - Communication avec le piège à noctuelles CAP TRAP de la société CAP 2020."
  s.description = "[IOT] - Communication avec le piège à noctuelles CAP TRAP de la société CAP 2020."
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "Rakefile", "README.rdoc"]
end
