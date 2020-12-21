# frozen_string_literal: true

require_relative 'lib/warden/megafono/version'

Gem::Specification.new do |spec|
  spec.name        = 'warden-megafono'
  spec.version     = Warden::Megafono::VERSION
  spec.authors     = ['']
  spec.email       = ['']
  spec.homepage    = ''
  spec.summary     = ''
  spec.description = ''
  spec.license     = 'MIT'
  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'warden'
  spec.add_dependency 'oauth2'
  spec.add_dependency 'megafono-domain'
end
