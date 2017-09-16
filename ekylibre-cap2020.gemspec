# coding: utf-8

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'ekylibre/cap2020/version'

Gem::Specification.new do |s|
  s.name        = 'ekylibre-cap2020'
  s.version     = Ekylibre::Cap2020::VERSION
  s.authors     = ['Jérémie Bonal', 'Alexandre Lécuelle']
  s.email       = ['jbonal@ekylibre.com', 'alecuelle@ekylibre.com']
  s.homepage    = 'https://forge.ekylibre.com/projects/cap-trap/repository'
  s.summary     = "CAP2020 integration: Cap'Trap"
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'Rakefile', 'README.rdoc']
end
