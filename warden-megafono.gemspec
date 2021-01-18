# frozen_string_literal: true

require_relative 'lib/warden/megafono/version'

Gem::Specification.new do |spec|
  spec.name        = 'warden-megafono'
  spec.version     = Warden::Megafono::VERSION
  spec.authors     = ['Megafono']
  spec.email       = ['devs@megafono.host']
  spec.homepage    = 'https://www.megafono.host'
  spec.summary     = 'Warden strategy for Megafono ID'
  spec.description = 'Warden strategy for Megafono single sign on'
  spec.license     = 'MIT'
  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'warden'
  spec.add_dependency 'oauth2'
  spec.add_dependency 'megafono-domain'
end
