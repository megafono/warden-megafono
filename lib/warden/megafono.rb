require 'bundler/setup'
require 'warden/megafono/engine'

module Warden
  module Megafono
    autoload :AuthenticationHelper, 'warden/megafono/authentication_helper.rb'


    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :client_id, :client_secret

      def initialize
      end
    end
  end
end