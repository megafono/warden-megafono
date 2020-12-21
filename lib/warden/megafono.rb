require 'bundler/setup'
require 'warden/megafono/engine'

module Warden
  module Megafono
    autoload :AuthenticationHelper, 'warden/megafono/authentication_helper.rb'
  end
end